# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

PYTHON_DEPEND="2"
WANT_AUTOCONF="2.5"
WX_GTK_VER=2.8

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fdo-mime flag-o-matic python versionator wxwidgets

MY_PV=$(get_version_component_range 1-2)
MY_REL="1"

DESCRIPTION="Cross-platform GUI front-end for the Subversion revision system"
HOMEPAGE="http://rapidsvn.tigris.org/"
SRC_URI="
	http://www.rapidsvn.org/download/release/${PV}/${P}.tar.gz
	doc? ( http://dev.gentoo.org/~jlec/distfiles/svncpp.dox.xz )"

LICENSE="GPL-2 LGPL-2.1 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

COMMON_DEP="
	dev-libs/apr
	dev-libs/apr-util
	dev-vcs/subversion
	x11-libs/wxGTK:2.8[X]"
DEPEND="${COMMON_DEP}
	doc? (
		dev-libs/libxslt
		app-text/docbook-sgml-utils
		app-doc/doxygen
		app-text/docbook-xsl-stylesheets )"
RDEPEND="${COMMON_DEP}"

PATCHES=(
	"${FILESDIR}/${P}-svncpp_link.patch"
	"${FILESDIR}/${P}-locale.patch" )

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( HACKING.txt TRANSLATIONS )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	if use doc; then
		mv "${WORKDIR}"/svncpp.dox doc/svncpp/ || die
	fi
	strip-linguas $(grep ^RAPIDSVN_LANGUAGES src/locale/Makefile.am | sed 's:RAPIDSVN_LANGUAGES=::g')
	sed \
		-e "/^RAPIDSVN_LANGUAGES/s:=.*:=${LINGUAS}:g" \
		-i src/locale/Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( --with-wx-config=${WX_CONFIG} )

	if use doc; then
		myeconfargs+=( --with-manpage=yes )
	else
		myeconfargs+=(
				--without-xsltproc
				--with-manpage=no
				--without-doxygen
				--without-dot )
	fi

	append-cppflags $( "${EPREFIX}"/usr/bin/apr-1-config --cppflags )

	myeconfargs+=(
		--with-svn-lib="${EPREFIX}"/usr/$(get_libdir)
		--with-svn-include="${EPREFIX}"/usr/include
		--with-apr-config="${EPREFIX}/usr/bin/apr-1-config"
		--with-apu-config="${EPREFIX}/usr/bin/apu-1-config"
		)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile -C doc/manpage manpage
}

src_install() {
	autotools-utils_src_install

	doicon src/res/rapidsvn.ico src/res/bitmaps/${PN}*.png
	make_desktop_entry rapidsvn "RapidSVN ${PV}" \
		"${EPREFIX}/usr/share/pixmaps/rapidsvn_32x32.png" \
		"RevisionControl;Development"

	if use doc ; then
		doman doc/manpage/${PN}.1
		dohtml "${S}"/doc/svncpp/html/*
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
