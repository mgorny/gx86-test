# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit leechcraft

DESCRIPTION="MusicBrainz client plugin for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug acoustid"

DEPEND="~app-leechcraft/lc-core-${PV}
	acoustid? ( media-libs/chromaprint )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_with acoustid MUSICZOMBIE_CHROMAPRINT)
	"
	cmake-utils_src_configure
}
