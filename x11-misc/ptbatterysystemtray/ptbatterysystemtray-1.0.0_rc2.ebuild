# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit qt4-r2

DESCRIPTION="A simple battery monitor in the system tray"
HOMEPAGE="https://gitorious.org/ptbatterysystemtray"
SRC_URI="https://gitorious.org/${PN}/${PN}/archive-tarball/${PV/_/-} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog README"

src_unpack() {
	default
	mv ${PN}-${PN} "${S}" || die
}

src_configure() {
	eqmake4 ${PN}.pro INSTALL_PREFIX=/usr
}
