# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base

DESCRIPTION="Graphical Portage frontend based on KDE4/Qt4"
HOMEPAGE="http://kuroo.sourceforge.net/"
SRC_URI="mirror://sourceforge/kuroo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="dev-db/sqlite"

RDEPEND="${DEPEND}
	app-portage/gentoolkit
	$(add_kdebase_dep kdesu)
	$(add_kdebase_dep kompare)
"
