# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=0
inherit eutils user

DESCRIPTION="ARIN rwhois daemon"
HOMEPAGE="http://projects.arin.net/rwhois/"
SRC_URI="http://projects.arin.net/rwhois/ftp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	epatch "${FILESDIR}"/rwhoisd-destdir.patch  || die "epatch failed"
	econf
	emake -j1
}

src_install () {
	emake -j1 install DESTDIR="${D}"
	doinitd "${FILESDIR}"/rwhoisd  || die "doinitd failed"
	newconfd "${FILESDIR}"/rwhoisd.conf rwhoisd || die "newconfd failed"
}

pkg_setup() {
	enewgroup rwhoisd
	enewuser rwhoisd -1 -1 /var/empty rwhoisd
}

pkg_postinst () {
	einfo "Please make sure to set the userid in rwhoisd.conf to rwhoisd."
	einfo "It is highly inadvisable to run rwhoisd as root."
}
