# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE application that runs in the background and responds to button presses by showing a tiny OSD"
HOMEPAGE="http://www.kde-apps.org/content/show.php/KOSD?content=81457"
SRC_URI="http://kde-apps.org/CONTENT/content-files/81457-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kmix)
"
RDEPEND="${DEPEND}"
