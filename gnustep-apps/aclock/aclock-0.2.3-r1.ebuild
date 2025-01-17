# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit gnustep-2

DESCRIPTION="Analog dockapp clock for GNUstep"
HOMEPAGE="http://www.linuks.mine.nu/aclock/"
SRC_URI="http://www.linuks.mine.nu/aclock/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

gnustep_config_script() {
	echo "echo ' * using smooth seconds'"
	echo "defaults write AClock SmoothSeconds YES"
	echo "echo ' * setting refresh rate to 0.1 seconds'"
	echo "defaults write AClock RefreshRate 0.1"
}
