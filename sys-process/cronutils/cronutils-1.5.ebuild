# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Utilities to assist running batch processing jobs"
HOMEPAGE="http://code.google.com/p/cronutils/"
SRC_URI="http://cronutils.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-D_XOPEN_SOURCE=500 ${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
}
