# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="http://root.cern.ch/git/root.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

PYTHON_COMPAT=( python2_{6,7} )

inherit elisp-common eutils fdo-mime fortran-2 multilib python-single-r1 \
	toolchain-funcs user versionator

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="http://root.cern.ch/"
DOC_URI="ftp://root.cern.ch/${PN}/doc"

SLOT="0/$(get_version_component_range 1-3 ${PV})"
LICENSE="LGPL-2.1"
IUSE="+X afs avahi c++0x doc emacs examples fits fftw graphviz
	kerberos ldap +math minimal mpi mysql odbc +opengl openmp
	oracle postgres	prefix pythia6 pythia8 python qt4 +reflex
	ruby sqlite	ssl xinetd xml xrootd"

REQUIRED_USE="
	!X? ( !opengl !qt4 )
	mpi? ( math !openmp )
	openmp? ( math !mpi )
	python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="
	app-arch/xz-utils:0=
	>=dev-lang/cfortran-4.4-r2
	dev-libs/libpcre:3=
	media-fonts/dejavu
	media-libs/freetype:2=
	media-libs/giflib:0=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib:0=
	virtual/jpeg:0
	virtual/shadow
	X? (
		media-libs/ftgl:0=
		media-libs/glew:0=
		x11-libs/libX11:0=
		x11-libs/libXext:0=
		x11-libs/libXpm:0=
		!minimal? (
			|| (
				media-libs/libafterimage:0=[gif,jpeg,png,tiff]
				>=x11-wm/afterstep-2.2.11:0=[gif,jpeg,png,tiff]
			)
			opengl? ( virtual/opengl virtual/glu x11-libs/gl2ps:0= )
			qt4? (
				dev-qt/qtgui:4=
				dev-qt/qtopengl:4=
				dev-qt/qt3support:4=
				dev-qt/qtsvg:4=
				dev-qt/qtwebkit:4=
				dev-qt/qtxmlpatterns:4=
			)
			x11-libs/libXft:0=
		)
	)
	!minimal? (
		afs? ( net-fs/openafs )
		avahi? ( net-dns/avahi:0= )
		emacs? ( virtual/emacs )
		fits? ( sci-libs/cfitsio:0= )
		fftw? ( sci-libs/fftw:3.0= )
		graphviz? ( media-gfx/graphviz:0= )
		kerberos? ( virtual/krb5 )
		ldap? ( net-nds/openldap:0= )
		math? (
			sci-libs/gsl:0=
			sci-mathematics/unuran:0=
			mpi? ( virtual/mpi )
		)
		mysql? ( virtual/mysql )
		odbc? ( || ( dev-db/libiodbc:0 dev-db/unixODBC:0 ) )
		oracle? ( dev-db/oracle-instantclient-basic:0= )
		postgres? ( dev-db/postgresql-base:= )
		pythia6? ( sci-physics/pythia:6= )
		pythia8? ( >=sci-physics/pythia-8.1.80:8= )
		python? ( ${PYTHON_DEPS} )
		ruby? (
			dev-lang/ruby
			dev-ruby/rubygems
		)
		sqlite? ( dev-db/sqlite:3= )
		ssl? ( dev-libs/openssl:0= )
		xml? ( dev-libs/libxml2:2= )
		xrootd? ( >=net-libs/xrootd-3.3.5:0= )
	)"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	reflex? ( dev-cpp/gccxml )
	xinetd? ( sys-apps/xinetd )"

PDEPEND="doc? ( ~app-doc/root-docs-${PV}[math=] )"

S="${WORKDIR}/${PN}"

# install stuff in ${P} and not ${PF} for easier tracking in root-docs
DOC_DIR="/usr/share/doc/${P}"

pkg_setup() {
	fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup
	echo
	elog "There are extra options on packages not yet in Gentoo:"
	elog "Afdsmgrd, AliEn, castor, Chirp, dCache, gfal, Globus, gLite,"
	elog "HDFS, Monalisa, MaxDB/SapDB, SRP."
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "For example, for SRP, you would set: "
	elog "EXTRA_ECONF=\"--enable-srp --with-srp-libdir=${EROOT%/}/usr/$(get_libdir)\""
	echo

	enewgroup rootd
	enewuser rootd -1 -1 /var/spool/rootd rootd

	use minimal && return

	if use math; then
		if use openmp; then
			if [[ $(tc-getCXX)$ == *g++* ]] && ! tc-has-openmp; then
				ewarn "You are using a g++ without OpenMP capabilities"
				die "Need an OpenMP capable compiler"
			else
				export USE_OPENMP=1 USE_PARALLEL_MINUIT2=1
			fi
		elif use mpi; then
			export USE_MPI=1 USE_PARALLEL_MINUIT2=1
		fi
	fi
	if use c++0x && [[ $(tc-getCXX) == *g++* ]] && \
		! version_is_at_least "4.7" "$(gcc-version)"; then
		eerror "You are using a g++ without C++0x capabilities"
		die "Need an C++0x capable compiler"
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-5.28.00b-glibc212.patch \
		"${FILESDIR}"/${PN}-5.32.00-prop-flags.patch \
		"${FILESDIR}"/${PN}-5.32.00-afs.patch \
		"${FILESDIR}"/${PN}-5.32.00-cfitsio.patch \
		"${FILESDIR}"/${PN}-5.32.00-chklib64.patch \
		"${FILESDIR}"/${PN}-5.32.00-dotfont.patch \
		"${FILESDIR}"/${PN}-5.34.05-nobyte-compile.patch \
		"${FILESDIR}"/${PN}-5.34.13-unuran.patch \
		"${FILESDIR}"/${PN}-5.34.13-desktop.patch

	# make sure we use system libs and headers
	rm montecarlo/eg/inc/cfortran.h README/cfortran.doc || die
	rm -r graf2d/asimage/src/libAfterImage || die
	rm -r graf3d/ftgl/{inc,src} || die
	rm -r graf2d/freetype/src || die
	rm -r graf3d/glew/{inc,src} || die
	rm -r core/pcre/src || die
	rm -r math/unuran/src/unuran-*.tar.gz || die
	LANG=C LC_ALL=C find core/zip -type f -name "[a-z]*" -print0 | \
		xargs -0 rm || die
	rm -r core/lzma/src/*.tar.gz || die
	rm graf3d/gl/{inc,src}/gl2ps.* || die
	sed -i -e 's/^GLLIBS *:= .* $(OPENGLLIB)/& -lgl2ps/' \
		graf3d/gl/Module.mk || die

	# In Gentoo, libPythia6 is called libpythia6
	# iodbc is in /usr/include/iodbc
	# pg_config.h is checked instead of libpq-fe.h
	sed -i \
		-e 's:libPythia6:libpythia6:g' \
		-e 's:$ODBCINCDIR:$ODBCINCDIR /usr/include/iodbc:' \
		-e 's:libpq-fe.h:pg_config.h:' \
		configure || die "adjusting configure for Gentoo failed"

	# prefixify the configure script
	sed -i \
		-e 's:/usr:${EPREFIX}/usr:g' \
		configure || die "prefixify configure failed"

	# fix reflex path (bug #497280)
	sed -i -e 's|${ROOTSYS}/lib|@libdir@|' config/genreflex.in || die

	# QTDIR only used for qt3 in gentoo, and configure looks for it.
	unset QTDIR
}

src_configure() {

	# the configure script is not the standard autotools
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--etcdir="${EPREFIX}/etc/root"
		--libdir="${EPREFIX}/usr/$(get_libdir)/${PN}"
		--docdir="${EPREFIX}${DOC_DIR}"
		--tutdir="${EPREFIX}${DOC_DIR}/examples/tutorials"
		--testdir="${EPREFIX}${DOC_DIR}/examples/tests"
		--with-cc="$(tc-getCC)"
		--with-cxx="$(tc-getCXX)"
		--with-f77="$(tc-getFC)"
		--with-ld="$(tc-getCXX)"
		--nohowto
	)

	if use minimal; then
		myconf+=( $(usex X --gminimal --minimal) )
	else
		myconf+=(
			--with-afs-shared=yes
			--with-sys-iconpath="${EPREFIX}/usr/share/pixmaps"
			--disable-builtin-afterimage
			--disable-builtin-ftgl
			--disable-builtin-freetype
			--disable-builtin-glew
			--disable-builtin-pcre
			--disable-builtin-zlib
			--disable-builtin-lzma
			--disable-cling
			--enable-astiff
			--enable-explicitlink
			--enable-gdml
			--enable-memstat
			--enable-shadowpw
			--enable-shared
			--enable-soversion
			--enable-table
			--fail-on-missing
			$(use_enable X x11)
			$(use_enable X asimage)
			$(use_enable X xft)
			$(use_enable afs)
			$(use_enable avahi bonjour)
			$(use_enable c++0x cxx11)
			$(use_enable fits fitsio)
			$(use_enable fftw fftw3)
			$(use_enable graphviz gviz)
			$(use_enable kerberos krb5)
			$(use_enable ldap)
			$(use_enable math gsl-shared)
			$(use_enable math genvector)
			$(use_enable math mathmore)
			$(use_enable math minuit2)
			$(use_enable math roofit)
			$(use_enable math tmva)
			$(use_enable math unuran)
			$(use_enable mysql)
			$(use_enable odbc)
			$(use_enable opengl)
			$(use_enable oracle)
			$(use_enable postgres pgsql)
			$(usex postgres \
				"--with-pgsql-incdir=$(pg_config --includedir)" "")
			$(use_enable prefix rpath)
			$(use_enable pythia6)
			$(use_enable pythia8)
			$(use_enable python)
			$(use_enable qt4 qt)
			$(use_enable qt4 qtgsi)
			$(use_enable reflex cintex)
			$(use_enable reflex)
			$(use_enable ruby)
			$(use_enable sqlite)
			$(use_enable ssl)
			$(use_enable xml)
			$(use_enable xrootd)
			${EXTRA_ECONF}
		)
	fi

	./configure ${myconf[@]} || die "configure failed"
}

src_compile() {
	emake \
		OPT="${CXXFLAGS}" \
		F77OPT="${FFLAGS}" \
		ROOTSYS="${S}" \
		LD_LIBRARY_PATH="${S}/lib"
	use emacs && ! use minimal && elisp-compile build/misc/*.el
}

daemon_install() {
	local daemons="rootd proofd"
	dodir /var/spool/rootd
	fowners rootd:rootd /var/spool/rootd
	dodir /var/spool/rootd/{pub,tmp}
	fperms 1777 /var/spool/rootd/{pub,tmp}

	for i in ${daemons}; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
		newconfd "${FILESDIR}"/${i}.confd ${i}
	done
	if use xinetd; then
		insinto /etc/xinetd
		doins "${S}"/etc/daemons/{rootd,proofd}.xinetd
	fi
}

desktop_install() {
	cd "${S}"
	echo "Icon=root-system-bin" >> etc/root.desktop
	domenu etc/root.desktop
	doicon build/package/debian/root-system-bin.png

	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins build/package/debian/application-x-root.png

	insinto /usr/share/icons/hicolor/48x48/apps
	doicon build/package/debian/root-system-bin.xpm
}

cleanup_install() {
	# Cleanup of files either already distributed or unused on Gentoo
	pushd "${ED}" > /dev/null
	rm usr/share/root/fonts/LICENSE || die
	rm etc/root/proof/*.sample || die
	rm -r etc/root/daemons || die
	# these should be in PATH
	mv etc/root/proof/utils/pq2/pq2* usr/bin/ || die
	rm ${DOC_DIR#/}/{INSTALL,LICENSE,COPYING.CINT} || die
	use examples || rm -r ${DOC_DIR#/}/examples || die
	cd usr/$(get_libdir)/root/cint/cint
	rm lib/posix/mktypes lib/dll_stl/setup lib/G__* || die
	rm lib/dll_stl/G__* lib/dll_stl/rootcint_* lib/posix/exten.o || die
	rm include/makehpib || die
	popd > /dev/null
}

src_install() {
	emake DESTDIR="${D}" install

	echo "LDPATH=${EPREFIX%/}/usr/$(get_libdir)/root" > 99root

	if ! use minimal; then
		use pythia8 && echo "PYTHIA8=${EPREFIX%/}/usr" >> 99root
		if use python; then
			echo "PYTHONPATH=${EPREFIX%/}/usr/$(get_libdir)/root" >> 99root
			python_optimize "${D}/usr/$(get_libdir)/root"
		fi
		use ruby && \
			echo "RUBYLIB=${EPREFIX%/}/usr/$(get_libdir)/root" >> 99root
		use emacs && elisp-install ${PN} build/misc/*.{el,elc}
		if use examples; then
			# these should really be taken care of by the root make install
			insinto ${DOC_DIR}/examples/tutorials/tmva
			doins -r tmva/test
		fi
	fi
	doenvd 99root

	# The build system installs Emacs support unconditionally in the wrong
	# directory. Remove it and call elisp-install in case of USE=emacs.
	rm -r "${ED}"/usr/share/emacs || die

	daemon_install
	desktop_install
	cleanup_install
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
