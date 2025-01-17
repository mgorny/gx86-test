# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB es et eu fr ga gl he hi hne
it ja km lt mai nb nds nl pa pl pt pt_BR ro ru sr sr@ijekavian sr@ijekavianlatin
sr@latin sv th tr uk zh_CN zh_TW"
KDE_HANDBOOK=optional
inherit kde4-base

DESCRIPTION="KPlayer is a KDE media player based on mplayer"
HOMEPAGE="https://projects.kde.org/projects/extragear/multimedia/kplayer"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="${DEPEND}
	|| ( >=media-video/mplayer-1.0_rc1 media-video/mplayer2 )
"
