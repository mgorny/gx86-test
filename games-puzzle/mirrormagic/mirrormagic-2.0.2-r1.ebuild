# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils toolchain-funcs games

DESCRIPTION="a game like Deflektor (C 64) or Mindbender (Amiga)"
HOMEPAGE="http://www.artsoft.org/mirrormagic/"
SRC_URI="http://www.artsoft.org/RELEASES/unix/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="sdl"

RDEPEND="!sdl? ( x11-libs/libX11 )
	sdl? (
		media-libs/libsdl[video]
		media-libs/sdl-mixer
		media-libs/sdl-image
	)"
DEPEND="${RDEPEND}
	!sdl? ( x11-libs/libXt )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-parallel.patch \
		"${FILESDIR}"/${P}-64bit.patch
	rm -f ${PN}
}

src_compile() {
	emake \
		-C src \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		OPTIONS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		RO_GAME_DIR="${GAMES_DATADIR}"/${PN} \
		RW_GAME_DIR="${GAMES_STATEDIR}"/${PN} \
		TARGET=$(use sdl && echo sdl || echo x11) \
		|| die "emake failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r graphics levels music sounds || die "doins failed"
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} "Mirror Magic II"
	dodoc CHANGES CREDITS README TODO
	prepgamesdirs
}
