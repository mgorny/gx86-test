# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
GCONF_DEBUG="yes"

inherit autotools gnome2 eutils

DESCRIPTION="assoGiate is an editor of the file types database for GNOME"
HOMEPAGE="http://www.kdau.com/projects/assogiate"
SRC_URI="http://www.kdau.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8:2
	>=dev-cpp/glibmm-2.8:2
	>=dev-cpp/gtkmm-2.8:2.4
	>=dev-cpp/libxmlpp-2.14
	>=dev-cpp/gnome-vfsmm-2.6"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	virtual/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# Fix desktop file
	epatch "${FILESDIR}/${P}-desktop.patch"

	# Fix compilation, bug #374911
	epatch "${FILESDIR}/${P}-typedialog.patch"

	# Fix building with glib-2.32, bug #417765
	epatch "${FILESDIR}/${P}-glib-2.32.patch"

	# Fix building with gcc-4.7
	epatch "${FILESDIR}/${P}-gcc-4.7.patch"

	eautoreconf
	gnome2_src_prepare
}
