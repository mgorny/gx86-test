# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="UNIX Shell for people already familiar with the C language"
HOMEPAGE="http://ccsh.sourceforge.net/"
SRC_URI="http://download.sourceforge.net/ccsh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	exeinto /bin
	doexe ccsh
	newman ccsh.man ccsh.1
	dodoc ChangeLog README TODO
}
