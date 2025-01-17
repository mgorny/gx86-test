# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils toolchain-funcs

DESCRIPTION="Generate English-plausible alphabetic mnemonics for a phone number"
HOMEPAGE="http://www.catb.org/~esr/letterize/"
SRC_URI="http://www.catb.org/~esr/letterize/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-printf.patch
}

src_compile() {
	tc-export CC
	emake || die "emake failed."
}

src_install() {
	dobin ${PN} || die "dobin failed."
	doman ${PN}.1
	dodoc README
}
