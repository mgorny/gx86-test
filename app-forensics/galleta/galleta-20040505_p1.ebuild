# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs

MY_P=${PN}_${PV/_p/_}
DESCRIPTION="IE Cookie Parser"
HOMEPAGE="http://sourceforge.net/projects/odessa/"
SRC_URI="mirror://sourceforge/odessa/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	cd src
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o galleta galleta.c -lm -lc || die "failed to compile"
}

src_install() {
	dodoc Readme.txt
	dobin src/galleta
}
