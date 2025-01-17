# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit games

DESCRIPTION="set of free cards sets"
HOMEPAGE="http://www.nongnu.org/cardpics/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	prepgamesdirs
}
