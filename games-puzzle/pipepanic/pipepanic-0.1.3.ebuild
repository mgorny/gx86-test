# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="A simple pipe connecting game"
HOMEPAGE="http://www.users.waitrose.com/~thunor/pipepanic/"
SRC_URI="http://www.users.waitrose.com/~thunor/pipepanic/dload/${P}-source.tar.gz"

LICENSE="GPL-2 FreeArt"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"

S=${WORKDIR}/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	# change harcoded data paths to match the install directory
	sed -i \
		-e "s:/opt/QtPalmtop/share/pipepanic/:${GAMES_DATADIR}/${PN}/:" \
		main.h \
		|| die "sed failed"
}

src_install() {
	dogamesbin "${PN}" || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}/${PN}"
	doins *.bmp || die "doins failed"
	newicon PipepanicIcon64.png ${PN}.png
	make_desktop_entry ${PN} "Pipepanic"

	dodoc AUTHORS ChangeLog README

	prepgamesdirs
}
