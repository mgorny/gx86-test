# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit eutils flag-o-matic

DESCRIPTION="low-level event loop management library for POSIX-based operating systems"
HOMEPAGE="http://liboop.ofb.net/"
SRC_URI="http://download.ofb.net/liboop/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="adns gnome tcl readline"

DEPEND="adns? ( net-libs/adns )
	gnome? ( dev-libs/glib )
	tcl? ( dev-lang/tcl )
	readline? ( sys-libs/readline )"

src_configure() {
	export ac_cv_path_PROG_LDCONFIG=true
	econf \
		$(use_with adns) \
		$(use_with gnome) \
		$(use_with tcl tcltk) \
		$(use_with readline) \
		--without-libwww \
		--disable-static
}

src_compile() {
	emake -j1
}

src_install() {
	default
	prune_libtool_files
}
