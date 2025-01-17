# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs

DESCRIPTION="Z80 macro cross-assembler"
HOMEPAGE="http://www.tim-mann.org/trs80resources.html"
SRC_URI="http://www.tim-mann.org/trs80/${PN}${PV//.}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" || die
}

src_install() {
	dobin zmac || die
	doman zmac.1 || die
	dodoc ChangeLog MAXAM NEWS README || die
}
