# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="Xjump clone with added features"
HOMEPAGE="http://gnujump.es.gnu.org"
SRC_URI="ftp://ftp.gnu.org/gnu/gnujump/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/opengl
	x11-libs/libX11"
RDEPEND=${DEPEND}

src_prepare() {
	append-libs -lm
}

src_install() {
	DOCS=( AUTHORS ChangeLog README )
	default

	newicon skins/xjump/hero1.0.png ${PN}.png
	make_desktop_entry ${PN} "GNUjump"

	prepgamesdirs
}
