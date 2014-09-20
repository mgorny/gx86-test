# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit leechcraft

DESCRIPTION="Provides searching with Google to other LeechCraft plugins"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
