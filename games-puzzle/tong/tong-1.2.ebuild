# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="Tetris and Pong in the same place at the same time"
HOMEPAGE="http://www.nongnu.org/tong/"
SRC_URI="http://www.nongnu.org/tong/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-makefile.patch" \
		"${FILESDIR}/${P}-fps.patch" \
		"${FILESDIR}/${P}-datadir.patch"
	sed -i \
		-e "s:\"media/:\"${GAMES_DATADIR}/${PN}/media/:" \
		media.cpp option.cpp option.h pong.cpp tetris.cpp text.cpp \
		|| die
	cp media/icon.png "${T}/${PN}.png" || die
}

src_install() {
	dogamesbin tong || die
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r media/ "${D}/${GAMES_DATADIR}/${PN}" || die
	dodoc CHANGELOG README making-of.txt CREDITS

	make_desktop_entry tong TONG
	doicon "${T}/${PN}.png"
	prepgamesdirs
}
