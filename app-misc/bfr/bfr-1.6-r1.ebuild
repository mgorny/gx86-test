# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs

DESCRIPTION="General-purpose command-line pipe buffer"
HOMEPAGE="http://www.glines.org/software/bfr"
SRC_URI="http://www.glines.org/bin/pk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE=""

pkg_setup() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS INSTALL ChangeLog NEWS README TODO || die
}
