# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt library for removable media and devices"
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
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	lxqt-base/liblxqt
	sys-fs/udisks:2
	x11-libs/libX11
	virtual/udev"
RDEPEND="${DEPEND}"
