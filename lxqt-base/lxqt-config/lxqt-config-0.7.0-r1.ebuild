# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt system configuration control center"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	lxqt-base/liblxqt
	razorqt-base/libqtxdg
	sys-libs/zlib
	x11-libs/libXcursor
	x11-libs/libXfixes"
RDEPEND="${DEPEND}"

src_install(){
	cmake-utils_src_install
	doman man/*.1 lxqt-config-cursor/man/*.1 lxqt-config-appearance/man/*.1
}
