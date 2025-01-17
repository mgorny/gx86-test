# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
#
# mozcoreconf.eclass : core options for mozilla
# inherit mozconfig-2 if you need USE flags

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads,sqlite'

inherit multilib flag-o-matic python-any-r1 versionator

IUSE="${IUSE} custom-cflags custom-optimization"

RDEPEND="x11-libs/libXrender
	x11-libs/libXt
	>=sys-libs/zlib-1.1.4"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	${PYTHON_DEPS}"

# mozconfig_annotate: add an annotated line to .mozconfig
#
# Example:
# mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
# => ac_add_options --enable-js-ultrasparc # building on ultrasparc
mozconfig_annotate() {
	declare reason=$1 x ; shift
	[[ $# -gt 0 ]] || die "mozconfig_annotate missing flags for ${reason}\!"
	for x in ${*}; do
		echo "ac_add_options ${x} # ${reason}" >>.mozconfig
	done
}

# mozconfig_use_enable: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_enable truetype freetype2
# => ac_add_options --enable-freetype2 # +truetype
mozconfig_use_enable() {
	declare flag=$(use_enable "$@")
	mozconfig_annotate "$(use $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_with: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_with kerberos gss-api /usr/$(get_libdir)
# => ac_add_options --with-gss-api=/usr/lib # +kerberos
mozconfig_use_with() {
	declare flag=$(use_with "$@")
	mozconfig_annotate "$(use $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_extension: enable or disable an extension based on a USE-flag
#
# Example:
# mozconfig_use_extension gnome gnomevfs
# => ac_add_options --enable-extensions=gnomevfs
mozconfig_use_extension() {
	declare minus=$(use $1 || echo -)
	mozconfig_annotate "${minus:-+}$1" --enable-extensions=${minus}${2}
}

mozversion_is_new_enough() {
	case ${PN} in
		firefox|thunderbird)
			if [[ $(get_version_component_range 1) -ge 17 ]] ; then
				return 0
			fi
		;;
		seamonkey)
			if [[ $(get_version_component_range 1) -eq 2 ]] && [[ $(get_version_component_range 2) -ge 14 ]] ; then
				return 0
			fi
		;;
	esac

	return 1
}

moz_pkgsetup() {
	# Ensure we use C locale when building
	export LANG="C"
	export LC_ALL="C"
	export LC_MESSAGES="C"
	export LC_CTYPE="C"

	# Ensure that we have a sane build enviroment
	export MOZILLA_CLIENT=1
	export BUILD_OPT=1
	export NO_STATIC_LIB=1
	export USE_PTHREADS=1
	export ALDFLAGS=${LDFLAGS}
	# ensure MOZCONFIG is not defined
	eval unset MOZCONFIG

	# nested configure scripts in mozilla products generate unrecognized options
	# false positives when toplevel configure passes downwards.
	export QA_CONFIGURE_OPTIONS=".*"

	if [[ $(gcc-major-version) -eq 3 ]]; then
		ewarn "Unsupported compiler detected, DO NOT file bugs for"
		ewarn "outdated compilers. Bugs opened with gcc-3 will be closed"
		ewarn "invalid."
	fi

	python-any-r1_pkg_setup
}

mozconfig_init() {
	declare enable_optimize pango_version myext x
	declare XUL=$([[ ${PN} == xulrunner ]] && echo true || echo false)
	declare FF=$([[ ${PN} == firefox ]] && echo true || echo false)
	declare SM=$([[ ${PN} == seamonkey ]] && echo true || echo false)
	declare TB=$([[ ${PN} == thunderbird ]] && echo true || echo false)

	####################################
	#
	# Setup the initial .mozconfig
	# See http://www.mozilla.org/build/configure-build.html
	#
	####################################

	case ${PN} in
		*xulrunner)
			cp xulrunner/config/mozconfig .mozconfig \
				|| die "cp xulrunner/config/mozconfig failed" ;;
		*firefox)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		seamonkey)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-application=suite ;;
		*thunderbird)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-application=mail ;;
	esac

	####################################
	#
	# CFLAGS setup and ARCH support
	#
	####################################

	# Set optimization level
	if [[ ${ARCH} == hppa ]]; then
		mozconfig_annotate "more than -O0 causes a segfault on hppa" --enable-optimize=-O0
	elif [[ ${ARCH} == x86 ]]; then
		mozconfig_annotate "less then -O2 causes a segfault on x86" --enable-optimize=-O2
	elif use custom-optimization || [[ ${ARCH} =~ (alpha|ia64) ]]; then
		# Set optimization level based on CFLAGS
		if is-flag -O0; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O0
		elif [[ ${ARCH} == ppc ]] && has_version '>=sys-libs/glibc-2.8'; then
			mozconfig_annotate "more than -O1 segfaults on ppc with glibc-2.8" --enable-optimize=-O1
		elif is-flag -O3; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O3
		elif is-flag -O1; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O1
		elif is-flag -Os; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_annotate "Gentoo's default optimization" --enable-optimize=-O2
		fi
	else
		# Enable Mozilla's default
		mozconfig_annotate "mozilla default" --enable-optimize
	fi

	# Strip optimization so it does not end up in compile string
	filter-flags '-O*'

	# Strip over-aggressive CFLAGS
	use custom-cflags || strip-flags

	# Additional ARCH support
	case "${ARCH}" in
	alpha)
		# Historically we have needed to add -fPIC manually for 64-bit.
		# Additionally, alpha should *always* build with -mieee for correct math
		# operation
		append-flags -fPIC -mieee
		;;

	ia64)
		# Historically we have needed to add this manually for 64-bit
		append-flags -fPIC
		;;

	ppc64)
		append-flags -fPIC -mminimal-toc
		;;
	esac

	# Go a little faster; use less RAM
	append-flags "$MAKEEDIT_FLAGS"

	####################################
	#
	# mozconfig setup
	#
	####################################

	mozconfig_annotate system_libs \
		--with-system-jpeg \
		--with-system-zlib \
		--enable-pango \
		--enable-system-cairo
		if ! $(mozversion_is_new_enough) ; then
			mozconfig_annotate system-libs --enable-svg
		fi

	mozconfig_annotate disable_update_strip \
		--disable-pedantic \
		--disable-updater \
		--disable-strip \
		--disable-install-strip
		if ! $(mozversion_is_new_enough) ; then
			mozconfig_annotate disable_update_strip \
				--disable-installer \
				--disable-strip-libs
		fi

	if [[ ${PN} != seamonkey ]]; then
		mozconfig_annotate basic_profile \
			--disable-profilelocking
			if ! $(mozversion_is_new_enough) ; then
				mozconfig_annotate basic_profile \
					--enable-single-profile \
					--disable-profilesharing
			fi
	fi

	# Here is a strange one...
	if is-flag '-mcpu=ultrasparc*' || is-flag '-mtune=ultrasparc*'; then
		mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
	fi

	# Currently --enable-elf-dynstr-gc only works for x86,
	# thanks to Jason Wever <weeve@gentoo.org> for the fix.
	if use x86 && [[ ${enable_optimize} != -O0 ]]; then
		mozconfig_annotate "${ARCH} optimized build" --enable-elf-dynstr-gc
	fi

	# jemalloc won't build with older glibc
	! has_version ">=sys-libs/glibc-2.4" && mozconfig_annotate "we have old glibc" --disable-jemalloc
}

# mozconfig_final: display a table describing all configuration options paired
# with reasons, then clean up extensions list
mozconfig_final() {
	declare ac opt hash reason
	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options .mozconfig | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	# Resolve multiple --enable-extensions down to one
	declare exts=$(sed -n 's/^ac_add_options --enable-extensions=\([^ ]*\).*/\1/p' \
		.mozconfig | xargs)
	sed -i '/^ac_add_options --enable-extensions/d' .mozconfig
	echo "ac_add_options --enable-extensions=${exts// /,}" >> .mozconfig
}

