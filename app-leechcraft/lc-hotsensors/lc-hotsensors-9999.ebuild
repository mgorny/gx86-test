# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit leechcraft

DESCRIPTION="Temperature sensors monitor plugin for LeechCraft"

# We should define license for this plugin explicitly
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}[qwt]
	~virtual/leechcraft-quark-sideprovider-${PV}
	dev-qt/qtdeclarative:4
	sys-apps/lm_sensors
	"
RDEPEND="${DEPEND}"
