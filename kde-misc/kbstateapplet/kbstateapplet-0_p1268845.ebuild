# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base

DESCRIPTION="Plasmoid that shows the state of keyboard leds"
HOMEPAGE="http://websvn.kde.org/trunk/playground/base/plasma/applets/kbstateapplet"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"
