# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="User friendly IRC client with unicode support and tcl/tk scripting"
SRC_URI="http://www.savirc.com/Downloads/savirc-Lin/${P}.tar.bz2"
HOMEPAGE="http://www.savirc.com/"

KEYWORDS="ppc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND=">=dev-lang/tcl-8.3.0
	>=dev-lang/tk-8.3.0"
DEPEND=""

src_install() {
	make PREFIX=/usr DESTDIR=${D}/usr install || die "make install failed"
}
