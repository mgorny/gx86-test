# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit leechcraft

DESCRIPTION="LeechCraft WM and compositor manager"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-libs/qjson
"
RDEPEND="${DEPEND}"
