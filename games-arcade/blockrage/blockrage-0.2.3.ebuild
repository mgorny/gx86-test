# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="Falling-blocks arcade game with a 2-player hotseat mode"
HOMEPAGE="http://blockrage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl"

# Removing error due to wrong detection of cross-compile mode
PATCHES=( "${FILESDIR}/${P}"-config.patch )

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog KNOWN_BUGS README TODO
	prepgamesdirs
}
