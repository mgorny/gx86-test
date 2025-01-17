# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Universal Hardware Inventory Tool, uhinv displays operating system and hardware info"
HOMEPAGE="http://developer.berlios.de/projects/uhinv/"
SRC_URI="mirror://berlios/uhinv/${P}.tar.gz"

KEYWORDS="amd64 arm hppa ~mips ppc ppc64 sparc x86"
SLOT="0"
LICENSE="GPL-2"

IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
}
