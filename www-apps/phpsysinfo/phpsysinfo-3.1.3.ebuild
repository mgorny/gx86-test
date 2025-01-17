# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit webapp

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP"
HOMEPAGE="http://rk4an.github.com/phpsysinfo/"
SRC_URI="https://github.com/rk4an/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"

RDEPEND="virtual/httpd-php
	dev-lang/php[simplexml,xml,xsl(+),xslt(+),unicode]"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG README*
	rm CHANGELOG COPYING README* || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	newins phpsysinfo.ini{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/phpsysinfo.ini
	webapp_src_install
}
