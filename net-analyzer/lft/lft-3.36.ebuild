# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Layer Four Traceroute: an advanced traceroute implementation"
HOMEPAGE="http://pwhois.org/lft/"
SRC_URI="http://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="VOSTROM"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG README TODO )

src_prepare() {
	sed -i Makefile.in -e '/[Ss]trip/d' || die
}
