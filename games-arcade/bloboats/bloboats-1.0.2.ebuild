# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="arcade-like boat racing game combining platform jumpers and elastomania / x-moto like games"
HOMEPAGE="http://bloboats.dy.fi/"
SRC_URI="http://mirror.kapsi.fi/bloboats.dy.fi/${P}.tar.gz"

LICENSE="GPL-2 CC-Sampling-Plus-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/libvorbis"

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch
	sed -i \
		-e "/PREFIX/s://:${D}:" \
		-e "/DATADIR/s:/usr/games/bloboats/data:${GAMES_DATADIR}/${PN}:" \
		-e "/BINARYDIR/s:/usr/bin:${GAMES_BINDIR}:" \
		-e "/CONFIGDIR/s:/etc:${GAMES_SYSCONFDIR}:" \
		-e "/CXXFLAGS_DEFAULT/s:-O2:${CXXFLAGS} \$(LDFLAGS):" \
		-e "/^CXX[ _]/d" \
		-e '/STRIP/d' \
		Makefile \
		|| die
}

src_install() {
	dogamesbin bin/bloboats || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/* || die
	insinto "$GAMES_SYSCONFDIR"
	doins bloboats.dirs || die
	dodoc readme.txt
	prepgamesdirs
}
