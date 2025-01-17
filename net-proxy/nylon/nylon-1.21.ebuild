# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="A lightweight SOCKS proxy server"
HOMEPAGE="http://monkey.org/~marius/nylon/"
SRC_URI="http://monkey.org/~marius/nylon/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-libs/libevent-0.6"
RDEPEND="${DEPEND}"

src_install() {
	einstall || die "make install failed"
	dodoc README THANKS

	insinto /etc ; doins "${FILESDIR}/nylon.conf"
	newinitd "${FILESDIR}/nylon.init" nylond
}
