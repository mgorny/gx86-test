# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="A tribute to Paradroid by Andrew Braybrook"
HOMEPAGE="http://night-hawk.sourceforge.net/nighthawk.html"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/games/arcade/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libXpm"

src_prepare() {
	epatch \
		"${FILESDIR}"/nighthawk.patch \
		"${FILESDIR}"/${P}-gcc42.patch
	sed -i -e 's:AC_FD_MSG:6:g' configure || die #218936
	sed -i -e '/LDFLAGS = /d' src/Makefile.in || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	prepgamesdirs
}
