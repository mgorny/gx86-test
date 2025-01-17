# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Yet Another Log Analyzer"
HOMEPAGE="http://yaala.org/"
SRC_URI="http://yaala.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodir /usr/share/yaala
	cp -pRx * "${D}"/usr/share/yaala/
}
