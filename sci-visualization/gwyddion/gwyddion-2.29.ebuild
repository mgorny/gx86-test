# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

PYTHON_DEPEND="python? 2"
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils fdo-mime gnome2-utils python autotools-utils

DESCRIPTION="Framework for Scanning Mode Microscopy data analysis"
HOMEPAGE="http://gwyddion.net/"
SRC_URI="http://gwyddion.net/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc fftw gnome kde nls opengl perl python ruby sourceview xml X"

RDEPEND="media-libs/libpng
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libXmu
	x11-libs/pango
	fftw? ( >=sci-libs/fftw-3 )
	gnome? ( gnome-base/gconf:2 )
	kde? ( >=kde-base/kdelibs-4 )
	opengl? ( virtual/opengl x11-libs/gtkglext )
	perl? ( dev-lang/perl )
	python? ( dev-python/pygtk:2 )
	ruby? ( dev-ruby/narray )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

MAKEOPTS+=" V=1"

pkg_setup() {
	use python && python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.25-libpng15.patch
}

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable doc gtk-doc)
		$(use_enable nls)
		$(use_enable python pygwy)
		$(use_with perl)
		$(use_with python)
		$(use_with ruby)
		$(use_with fftw fftw3)
		$(use_with opengl gl) \
		$(use_with sourceview gtksourceview)
		$(use_with xml libxml2)
		$(use_with X x)
		$(use_with kde kde4-thumbnailer)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use python && dodoc modules/pygwy/README.pygwy
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	fdo-mime_desktop_database_update
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
