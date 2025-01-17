# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

CDOGS_DATA="cdogs-data-2007-07-06"
DESCRIPTION="A port of the old DOS arcade game C-Dogs"
HOMEPAGE="http://lumaki.com/code/cdogs"
SRC_URI="http://icculus.org/cdogs-sdl/files/src/${P}.tar.bz2
	http://icculus.org/cdogs-sdl/files/data/${CDOGS_DATA}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer"

S=${WORKDIR}/${P}/src

src_unpack() {
	unpack ${A}
	mv ${CDOGS_DATA} ${P}/data || die "Failed moving data around"
}

src_prepare() {
	sed -i \
		-e "/^CF_OPT/d" \
		-e "/^CC/d" \
		Makefile \
		|| die "sed failed"
	sed -i \
		-e "/\bopen(/s/)/, 0666)/" \
		files.c \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	emake I_AM_CONFIGURED=yes \
		SYSTEM="\"linux\"" \
		STRIP=true \
		DATADIR="${GAMES_DATADIR}/${PN}" \
		cdogs || die "emake failed"
}

src_install() {
	dogamesbin cdogs || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r ../data/* || die "doins failed"
	newicon ../data/cdogs_icon.png ${PN}.png
	dodoc ../doc/{README,AUTHORS,ChangeLog,README_DATA,TODO,original_readme.txt}
	make_desktop_entry "cdogs -fullscreen" C-Dogs
	prepgamesdirs
}
