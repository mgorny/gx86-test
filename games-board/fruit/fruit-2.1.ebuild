# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils versionator games

MY_PV=$(replace_all_version_separators '')
MY_P=${PN}_${MY_PV}_linux
DESCRIPTION="UCI-only chess engine"
HOMEPAGE="http://arctrix.com/nas/fruit/"
SRC_URI="http://arctrix.com/nas/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}/src

src_prepare() {
	epatch "${FILESDIR}/${P}"-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		option.cpp \
		|| die "sed option.cpp failed"
	sed -i \
		-e '/^CXX/d' \
		-e '/^LDFLAGS/d' \
		Makefile \
		|| die "sed Makefile failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins ../book_small.bin || die "doins failed"
	dodoc ../readme.txt ../technical_10.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To use this engine you need to install a UCI chess GUI"
	elog "e.g. games-board/glchess"
}
