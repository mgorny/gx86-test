# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Use keyboard shortcuts in the blackbox wm"
HOMEPAGE="http://bbkeys.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-wm/blackbox-0.70.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${D}"/usr/share/doc
	dodoc AUTHORS BUGS ChangeLog NEWS README || die

	echo PRELINK_PATH_MASK=/usr/bin/bbkeys > "${T}"/99bbkeys
	doenvd "${T}"/99bbkeys || die
}
