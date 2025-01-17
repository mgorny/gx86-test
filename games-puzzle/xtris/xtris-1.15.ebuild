# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils toolchain-funcs games

DESCRIPTION="a networked Tetris-like game"
HOMEPAGE="http://www.iagora.com/~espel/xtris/xtris.html"
SRC_URI="http://www.iagora.com/~espel/xtris/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libX11"

S=${WORKDIR}/${PN}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		BINDIR="${GAMES_BINDIR}" \
		MANDIR=/usr/share/man \
		CFLAGS="${CFLAGS}" \
		EXTRALIBS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dogamesbin xtris xtserv xtbot || die "dogamesbin failed"
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} xtris ${PN}
	doman xtris.6 xtserv.6 xtbot.6
	dodoc ChangeLog PROTOCOL README
	prepgamesdirs
}
