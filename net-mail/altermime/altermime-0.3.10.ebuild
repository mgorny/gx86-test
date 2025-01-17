# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION=" alterMIME is a small program which is used to alter your mime-encoded mailpacks"
SRC_URI="http://www.pldaniels.com/altermime/${P}.tar.gz"
HOMEPAGE="http://pldaniels.com/altermime/"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -i \
		-e 's:-Werror::' \
		-e "/^CFLAGS[[:space:]]*=/ s/-O2/${CFLAGS}/" \
		-e 's/${CFLAGS} altermime.c/${CFLAGS} ${LDFLAGS} altermime.c/' \
		Makefile || die

	epatch "${FILESDIR}"/${P}-fprintf-fixes.patch \
		"${FILESDIR}"/${P}-MIME_headers-overflow.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	dobin altermime || die
	dodoc CHANGELOG README || die
}
