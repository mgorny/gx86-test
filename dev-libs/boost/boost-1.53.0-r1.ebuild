# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit eutils flag-o-matic multilib multiprocessing python-r1 toolchain-funcs versionator

MY_P=${PN}_$(replace_all_version_separators _)

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
MAJOR_V="$(get_version_component_range 1-2)"
SLOT="0/${MAJOR_V}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd ~x86-linux"
IUSE="debug doc icu +nls mpi python static-libs +threads tools"

RDEPEND="icu? ( >=dev-libs/icu-3.6:= )
	!icu? ( virtual/libiconv )
	mpi? ( || ( sys-cluster/openmpi[cxx] sys-cluster/mpich2[cxx,threads] ) )
	python? ( ${PYTHON_DEPS} )
	app-arch/bzip2
	sys-libs/zlib
	!app-admin/eselect-boost"
DEPEND="${RDEPEND}
	=dev-util/boost-build-${MAJOR_V}*"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

create_user-config.jam() {
	local compiler compiler_version compiler_executable

	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
		compiler_executable="$(tc-getCXX)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
		compiler_executable="$(tc-getCXX)"
	fi
	local mpi_configuration python_configuration

	if use mpi; then
		mpi_configuration="using mpi ;"
	fi

	if use python; then
		python_configuration="using python : : ${PYTHON} ;"
	fi

	cat > user-config.jam << __EOF__
using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
${mpi_configuration}
${python_configuration}
__EOF__
}

pkg_setup() {
	# Bail out on unsupported build configuration, bug #456792
	if [[ -f "${EROOT}etc/site-config.jam" ]]; then
		grep -q gentoorelease "${EROOT}etc/site-config.jam" && grep -q gentoodebug "${EROOT}etc/site-config.jam" ||
		(
			eerror "You are using custom ${EROOT}etc/site-config.jam without defined gentoorelease/gentoodebug targets."
			eerror "Boost can not be built in such configuration."
			eerror "Please, either remove this file or add targets from ${EROOT}usr/share/boost-build/site-config.jam to it."
			die
		)
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-1.48.0-mpi_python3.patch" \
		"${FILESDIR}/${PN}-1.51.0-respect_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.51.0-support_dots_in_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.48.0-no_strict_aliasing_python2.patch" \
		"${FILESDIR}/${PN}-1.48.0-disable_libboost_python3.patch" \
		"${FILESDIR}/${PN}-1.48.0-python_linking.patch" \
		"${FILESDIR}/${PN}-1.48.0-disable_icu_rpath.patch"
	epatch	"${FILESDIR}/${PN}-1.53.0-library_status.patch" # bug 459112
	epatch	"${FILESDIR}/${PN}-1.53.0-glibc-2.18-compat.patch" # bug 482372
	epatch "${FILESDIR}/${PN}-1.52.0-threads.patch"

	# Avoid a patch for now
	for file in libs/context/src/asm/*.S; do
		cat - >> $file <<EOF

#if defined(__linux__) && defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
EOF
	done

	epatch_user
}

ejam() {
	echo b2 "$@"
	b2 "$@"
}

src_configure() {
	# Workaround for too many parallel processes requested, bug #506064
	[ "$(makeopts_jobs)" -gt 64 ] && MAKEOPTS="${MAKEOPTS} -j64"

	OPTIONS="$(usex debug gentoodebug gentoorelease) -j$(makeopts_jobs) -q -d+2 --user-config=${S}/user-config.jam"

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	elif [[ ${CHOST} == *-winnt* ]]; then
		compiler=parity
		if [[ $($(tc-getCXX) -v) == *trunk* ]]; then
			compilerVersion=trunk
		else
			compilerVersion=$($(tc-getCXX) -v | sed '1q' \
				| sed -e 's,\([a-z]*\) \([0-9]\.[0-9]\.[0-9][^ \t]*\) .*,\2,')
		fi
		compilerExecutable=$(tc-getCXX)
	fi

	# bug 298489
	if use ppc || use ppc64; then
		[[ $(gcc-version) > 4.3 ]] && append-flags -mno-altivec
	fi

	# Do _not_ use C++11 yet, make sure to force GNU C++ 98 standard.
	append-cxxflags -std=gnu++98

	use icu && OPTIONS+=" -sICU_PATH=${EPREFIX}/usr"
	use icu || OPTIONS+=" --disable-icu boost.locale.icu=off"
	use mpi || OPTIONS+=" --without-mpi"
	use python || OPTIONS+=" --without-python"
	use nls || OPTIONS+=" --without-locale"

	OPTIONS+=" pch=off --boost-build=${EPREFIX}/usr/share/boost-build --prefix=\"${ED}usr\" --layout=system threading=$(usex threads multi single) link=$(usex static-libs shared,static shared)"
	OPTIONS+=" --without-context"

	[[ ${CHOST} == *-winnt* ]] && OPTIONS+=" -sNO_BZIP2=1"
}

src_compile() {
	export BOOST_ROOT="${S}"
	PYTHON_DIRS=""
	MPI_PYTHON_MODULE=""

	building() {
		create_user-config.jam

		ejam ${OPTIONS} \
			$(use python && echo --python-buildid=${EPYTHON#python}) \
			|| die "Building of Boost libraries failed"

		if use python; then
			if [[ -z "${PYTHON_DIRS}" ]]; then
				PYTHON_DIRS="$(find bin.v2/libs -name python | sort)"
			else
				if [[ "${PYTHON_DIRS}" != "$(find bin.v2/libs -name python | sort)" ]]; then
					die "Inconsistent structure of build directories"
				fi
			fi

			local dir
			for dir in ${PYTHON_DIRS}; do
				mv ${dir} ${dir}-${EPYTHON} \
					|| die "Renaming of '${dir}' to '${dir}-${EPYTHON}' failed"
			done

			if use mpi; then
				if [[ -z "${MPI_PYTHON_MODULE}" ]]; then
					MPI_PYTHON_MODULE="$(find bin.v2/libs/mpi/build/*/gentoo* -name mpi.so)"
					if [[ "$(echo "${MPI_PYTHON_MODULE}" | wc -l)" -ne 1 ]]; then
						die "Multiple mpi.so files found"
					fi
				else
					if [[ "${MPI_PYTHON_MODULE}" != "$(find bin.v2/libs/mpi/build/*/gentoo* -name mpi.so)" ]]; then
						die "Inconsistent structure of build directories"
					fi
				fi

				mv stage/lib/mpi.so stage/lib/mpi.so-${EPYTHON} \
					|| die "Renaming of 'stage/lib/mpi.so' to 'stage/lib/mpi.so-${EPYTHON}' failed"
			fi
		fi
	}
	if use python; then
		python_foreach_impl building
	else
		building
	fi

	if use tools; then
		pushd tools > /dev/null || die

		ejam ${OPTIONS} \
			|| die "Building of Boost tools failed"
		popd > /dev/null || die
	fi
}

src_install () {
	installation() {
		create_user-config.jam

		if use python; then
			local dir
			for dir in ${PYTHON_DIRS}; do
				cp -pr ${dir}-${EPYTHON} ${dir} \
					|| die "Copying of '${dir}-${EPYTHON}' to '${dir}' failed"
			done

			if use mpi; then
				cp -p stage/lib/mpi.so-${EPYTHON} "${MPI_PYTHON_MODULE}" \
					|| die "Copying of 'stage/lib/mpi.so-${EPYTHON}' to '${MPI_PYTHON_MODULE}' failed"
				cp -p stage/lib/mpi.so-${EPYTHON} stage/lib/mpi.so \
					|| die "Copying of 'stage/lib/mpi.so-${EPYTHON}' to 'stage/lib/mpi.so' failed"
			fi
		fi

		ejam ${OPTIONS} \
			--includedir="${ED}usr/include" \
			--libdir="${ED}usr/$(get_libdir)" \
			$(use python && echo --python-buildid=${EPYTHON#python}) \
			install || die "Installation of Boost libraries failed"

		if use python; then
			rm -r ${PYTHON_DIRS} || die

			# Move mpi.so Python module to Python site-packages directory.
			# https://svn.boost.org/trac/boost/ticket/2838
			if use mpi; then
				local moddir=$(python_get_sitedir)/boost
				# moddir already includes eprefix
				mkdir -p "${D}${moddir}" || die
				mv "${ED}usr/$(get_libdir)/mpi.so" "${D}${moddir}" || die
				cat << EOF > "${D}${moddir}/__init__.py" || die
import sys
if sys.platform.startswith('linux'):
	import DLFCN
	flags = sys.getdlopenflags()
	sys.setdlopenflags(DLFCN.RTLD_NOW | DLFCN.RTLD_GLOBAL)
	from . import mpi
	sys.setdlopenflags(flags)
	del DLFCN, flags
else:
	from . import mpi
del sys
EOF
			fi

			python_optimize
		fi
	}
	if use python; then
		python_foreach_impl installation
	else
		installation
	fi

	if ! use python; then
		rm -r "${ED}"/usr/include/boost/python* || die
	fi

	if ! use nls; then
		rm -r "${ED}"/usr/include/boost/locale || die
	fi

	rm -r "${ED}"/usr/include/boost/context || die
	rm -r "${ED}"/usr/include/boost/coroutine || die

	if use doc; then
		find libs/*/* -iname "test" -or -iname "src" | xargs rm -rf
		dohtml \
			-A pdf,txt,cpp,hpp \
			*.{htm,html,png,css} \
			-r doc
		dohtml -A pdf,txt -r tools
		insinto /usr/share/doc/${PF}/html
		doins -r libs
		doins -r more

		# To avoid broken links
		insinto /usr/share/doc/${PF}/html
		doins LICENSE_1_0.txt

		dosym /usr/include/boost /usr/share/doc/${PF}/html/boost
	fi

	pushd "${ED}usr/$(get_libdir)" > /dev/null || die

	local ext=$(get_libname)
	if use threads; then
		local f
		for f in *${ext}; do
			dosym ${f} /usr/$(get_libdir)/${f/${ext}/-mt${ext}}
		done
	fi

	popd > /dev/null || die

	if use tools; then
		dobin dist/bin/*

		insinto /usr/share
		doins -r dist/share/boostbook
	fi

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED}"usr/lib/*.dylib; do
			if [[ -f ${d} ]]; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
				# fix references to other libs
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "^libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					ebegin "    correcting reference to ${r}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}

pkg_preinst() {
	# Yai for having symlinks that are nigh-impossible to remove without
	# resorting to dirty hacks like these. Removes lingering symlinks
	# from the slotted versions.
	local symlink
	for symlink in "${EROOT}usr/include/boost" "${EROOT}usr/share/boostbook"; do
		[[ -L ${symlink} ]] && rm -f "${symlink}"
	done
}

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
src_test() { :; }
