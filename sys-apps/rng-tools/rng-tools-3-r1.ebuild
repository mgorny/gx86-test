# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils autotools

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="http://gkernel.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkernel/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am
	epatch "${FILESDIR}"/test-for-argp.patch
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog
	newinitd "${FILESDIR}/rngd-initd-${PV}" rngd
	newconfd "${FILESDIR}/rngd-confd-${PV}" rngd
}
