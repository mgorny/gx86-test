# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs

DESCRIPTION="tool to reliably distribute binary data using UDP broadcasting techniques"
HOMEPAGE="http://www.wudika.de/~jan/netpipe/"
SRC_URI="http://www.wudika.de/~jan/${PN}/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:^OPT=.*:OPT = ${CFLAGS} ${LDFLAGS}:" \
		-e "s:^CC=.*:CC = $(tc-getCC):" \
		Makefile || die "sed failed"
}

src_install() {
	dobin netpipe || die "dobin failed"
	dodoc DOCUMENTATION INSTALL TECH-NOTES || die
}
