# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit autotools eutils

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
SRC_URI="http://ctdb.samba.org/packages/redhat/RHEL5/${P}.tgz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-libs/popt"
RDEPEND="${DEPEND}"

src_prepare() {
	AT_M4DIR="-I ${S}/lib/replace -I ${S}/lib/talloc -I ${S}/lib/tdb -I ${S}/lib/popt -I ${S}/lib/events"
	autotools_run_tool autoheader ${AT_M4DIR} || die "running autoheader failed"
	eautoconf ${AT_M4DIR}

	epatch "${FILESDIR}"/${PN}-functions.patch
	epatch "${FILESDIR}"/${PN}-50.samba_gentoo.patch
	epatch "${FILESDIR}"/${PN}-41.httpd_gentoo.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc "${D}/usr/share/doc/ctdb/README.eventscripts"
	rm -rf "${D}/usr/share/doc/ctdb"

	dohtml web/* doc/*.html

	newinitd "${FILESDIR}/${PN}.initd" ctdb || die "newinitd failed"
	newconfd "${S}/config/ctdb.sysconfig" ctdb || die "newconfd failed"
}
