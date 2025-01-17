# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit webapp

DESCRIPTION="Ampache is a PHP-based tool for managing, updating and playing your audio files via a web interface"
HOMEPAGE="http://www.ampache.org/"
SRC_URI="http://www.ampache.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="dev-lang/php[gd,hash,iconv,mysql,session,unicode,xml,zlib]
		 || ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"
DEPEND=""

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc docs/*
	rm -rf docs/

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_postinst_txt en "${FILESDIR}"/installdoc.txt
	webapp_src_install
}

pkg_postinst() {
	elog "Install and upgrade instructions can be found here:"
	elog "  /usr/share/doc/${P}/INSTALL.bz2"
	elog "  /usr/share/doc/${P}/MIGRATION.bz2"
	webapp_pkg_postinst
}
