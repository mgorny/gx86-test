# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI=2

inherit eutils games

DESCRIPTION="An SDL clone of Gladiator, a classic RPG game"
HOMEPAGE="http://snowstorm.sourceforge.net/"
SRC_URI="mirror://sourceforge/snowstorm/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl"

PATCHES=(
	"${FILESDIR}"/${PV}-gladpack.c.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-ovfl.patch
)

src_configure() {
	egamesconf \
		--prefix=/usr \
		--bindir="${GAMES_BINDIR}" \
		--datadir="${GAMES_DATADIR}/${PN}" \
		 || die
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		docdir="${D}"/usr/share/doc/${PF} \
		|| die "emake install failed"
	prepalldocs
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry openglad OpenGladiator
	prepgamesdirs
}
