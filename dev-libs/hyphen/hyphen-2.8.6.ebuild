# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="ALTLinux hyphenation library"
HOMEPAGE="http://hunspell.sf.net"
SRC_URI="mirror://sourceforge/hunspell/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-text/hunspell"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README* THANKS TODO"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	docinto pdf
	dodoc doc/*.pdf

	rm -f "${ED}"usr/lib*/libhyphen.la
}
