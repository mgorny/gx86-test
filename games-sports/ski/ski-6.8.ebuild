# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit python-single-r1 games

DESCRIPTION="A simple text-mode skiing game"
HOMEPAGE="http://www.catb.org/~esr/ski/"
SRC_URI="http://www.catb.org/~esr/ski/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	dogamesbin ski
	dodoc NEWS README
	doman ski.6
	domenu ski.desktop
	doicon ski.png
	prepgamesdirs
	python_fix_shebang "${ED}${GAMES_BINDIR}"
}
