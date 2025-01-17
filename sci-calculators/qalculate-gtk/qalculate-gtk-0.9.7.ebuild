# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
GCONF_DEBUG=no
inherit eutils gnome2

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=sci-libs/libqalculate-0.9.7
	>=sci-libs/cln-1.2
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	gnome? ( >=gnome-base/libgnome-2 )"
DEPEND="${RDEPEND}
	app-text/rarian
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="$(use_with gnome libgnome)"
}

src_prepare() {
	# Required by src_test() and `make check`
	echo data/periodictable.glade > po/POTFILES.skip
	epatch "${FILESDIR}"/${P}-entry.patch
	gnome2_src_prepare
}
