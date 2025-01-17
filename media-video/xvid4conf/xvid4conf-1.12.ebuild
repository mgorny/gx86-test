# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="GTK2-configuration dialog for xvid4"
HOMEPAGE="http://cvs.exit1.org/cgi-bin/viewcvs.cgi/xvid4conf/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.2.4:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dodir /usr/{include,lib}
	einstall || die

	dodoc AUTHORS ChangeLog README
}
