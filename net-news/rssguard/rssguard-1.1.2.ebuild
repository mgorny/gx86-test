# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit cmake-utils

DESCRIPTION="A tiny RSS and Atom feed reader"
HOMEPAGE="http://code.google.com/p/rss-guard/"
SRC_URI="http://rss-guard.googlecode.com/files/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	x11-themes/hicolor-icon-theme
	dbus? ( dev-qt/qtdbus:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rss-guard"
DOCS=( resources/text/AUTHORS resources/text/CHANGELOG )

src_prepare() {
	sed -e '/Encoding/d' -i resources/desktops/${PN}.desktop || die 'sed failed'
	epatch_user
}
