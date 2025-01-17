# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="backend library for the maitretarot clients"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="http://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="=dev-libs/glib-2*
	dev-libs/libxml2
	dev-games/libmaitretarot"

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
