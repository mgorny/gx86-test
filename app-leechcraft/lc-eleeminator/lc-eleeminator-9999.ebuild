# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit leechcraft

DESCRIPTION="Embedded LeechCraft Terminal Emulator"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"
