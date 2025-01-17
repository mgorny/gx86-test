# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Squash the monsters with your levitation worker gnome"
HOMEPAGE="http://people.iola.dk/olau/monster-masher/"
SRC_URI="http://people.iola.dk/olau/monster-masher/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libSM
	>=dev-cpp/gtkmm-2.6:2.4
	>=dev-cpp/gconfmm-2.6
	>=dev-cpp/libglademm-2.4:2.4
	>=dev-cpp/libgnomecanvasmm-2.6:2.6
	gnome-base/libgnome
	media-libs/libcanberra"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# Port to libcanberra, bug #348605
	epatch "${FILESDIR}"/${P}-libcanberra.patch
	# build with newer glib - bug #424313
	sed -i -e 's:glib/gtypes:glib:' src/pixbuf-drawing.hpp || die

	intltoolize --force --copy --automake || die
	eautoreconf

	gnome2_src_prepare
}

src_install() {
	DOCS="AUTHORS ChangeLog README" gnome2_src_install
}
