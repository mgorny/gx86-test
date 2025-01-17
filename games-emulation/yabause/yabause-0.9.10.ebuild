# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit games

DESCRIPTION="A Sega Saturn emulator"
HOMEPAGE="http://yabause.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="openal sdl opengl"

RDEPEND="x11-libs/gtk+:2
	x11-libs/gtkglext
	virtual/opengl
	virtual/glu
	media-libs/freeglut
	openal? ( media-libs/openal )
	sdl? ( media-libs/libsdl[opengl?,video] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--datadir=/usr/share \
		--with-port=gtk \
		$(use_with sdl) \
		$(use_with openal)
}

src_compile() {
	emake -C src/c68k gen68k || die "emake failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog GOALS README README.LIN
	prepgamesdirs
}
