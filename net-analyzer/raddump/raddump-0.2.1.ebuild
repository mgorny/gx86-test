# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit autotools

DESCRIPTION="RADIUS packet interpreter"
HOMEPAGE="http://sourceforge.net/projects/raddump/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=net-analyzer/tcpdump-3.8.3-r1"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README TODO ChangeLog
}
