# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit leechcraft

DESCRIPTION="System tray quark for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4
	x11-libs/libXdamage
	x11-libs/libXrender"
RDEPEND="${DEPEND}
	 ~virtual/leechcraft-quark-sideprovider-${PV}"
