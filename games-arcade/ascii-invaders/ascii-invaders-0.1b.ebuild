# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit games

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="http://www.ip9.org/munro/invaders/"
SRC_URI="http://www.ip9.org/munro/invaders/invaders${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos"
IUSE=""

DEPEND="sys-libs/ncurses"

S=${WORKDIR}/invaders

src_prepare() {
	rm -f Makefile
}

src_compile() {
	emake LDLIBS=-lncurses invaders || die "emake failed"
}

src_install() {
	newgamesbin invaders ${PN} || die "newgamesbin failed"
	dodoc TODO
	prepgamesdirs
}
