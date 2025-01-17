# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: monitors on KDE Kickerapplet kvdrmon"
HOMEPAGE="http://vdr-statusleds.sf.net/kvdrmon"
SRC_URI="mirror://sourceforge/vdr-statusleds/${P}.tgz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-remove-menu-entry.diff" )
