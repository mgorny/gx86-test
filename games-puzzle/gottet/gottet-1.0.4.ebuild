# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils qt4-r2 games

DESCRIPTION="A tetris clone based on Qt4"
HOMEPAGE="http://gottcode.org/gottet/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin ${PN} || die
	dodoc ChangeLog
	doicon icons/${PN}.png
	domenu icons/${PN}.desktop
	prepgamesdirs
}
