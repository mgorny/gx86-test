# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit games

DESCRIPTION="A parodic fantasy module for Neverwinter Nights"
HOMEPAGE="http://pixelscapes.com/penultima"
SRC_URI="http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1661/Penultima_0_Penultima_City.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1665/Penultima_1_Pest_Control.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1667/Penultima_2_Deweys_Decimal.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1669/Penultima_3_Hazard_Pay.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1671/Penultima_4_Clucking_Hositle.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1673/Penultima_5_Home_Sweet_Home.zip"

# redistributable per http://stefangagne.com/penultima/modules.html
LICENSE="freedist"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="games-rpg/nwn"

src_install() {
	insinto "${GAMES_PREFIX_OPT}"/nwn/modules
	newins "Penultima City.mod" "Penultima 0 (Penultima City).mod"
	newins "Pest Control.mod" "Penultima 1 (Pest Control).mod"
	newins "Dewey's Decimal.mod" "Penultima 2 (Dewey's Decimal).mod"
	newins "Hazard Pay.mod" "Penultima 3 (Hazard Pay).mod"
	newins "Clucking Hostile.mod" "Penultima 4 (Clucking Hostile).mod"
	newins "Home Sweet Home.mod" "Penultima 5 (Home Sweet Home).mod"

	insinto "${GAMES_PREFIX_OPT}"/nwn/penultima
	doins *.txt

	prepgamesdirs
}
