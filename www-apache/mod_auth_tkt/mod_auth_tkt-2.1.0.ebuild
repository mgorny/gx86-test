# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# test suite is completely broken
RESTRICT="test"

inherit apache-module

DESCRIPTION="Apache module for cookie based authentication"
HOMEPAGE="http://www.openfusion.com.au/labs/mod_auth_tkt/"
SRC_URI="http://www.openfusion.com.au/labs/dist/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTH_TKT"

DOCFILES="README"

need_apache2_2

src_compile() {
	./configure --apachever=2.2 --apxs=${APXS} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
	pod2man --section=5 --release=${PV} doc/${PN}.{pod,5}
	doman doc/${PN}.5
}

pkg_postinst() {
	apache-module_pkg_postinst
	einfo "See 'man mod_auth_tkt' for details on the individual directives."
	einfo "Remember to change shared secret 'TKTAuthSecret' before using!"
	einfo
}
