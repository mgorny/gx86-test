# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit games

DESCRIPTION="Run games in a separate X session"
HOMEPAGE="http://xgame.tlhiv.com/"
SRC_URI="http://downloads.tlhiv.com/xgame/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/gtk2-perl-1.040"

src_install() {
	dogamesbin xgame-gtk2 || die "dogamesbin failed"
	dodoc README
	prepgamesdirs
}
