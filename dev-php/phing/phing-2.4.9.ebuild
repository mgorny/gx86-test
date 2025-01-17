# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
inherit php-pear-lib-r1 eutils

DESCRIPTION="PHP project build system based on Apache Ant"
HOMEPAGE="http://www.phing.info/"
SRC_URI="http://pear.phing.info/get/phing-${PV/_/}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+minimal"

DEPEND=""
RDEPEND="!minimal? ( >=dev-php/PEAR-PhpDocumentor-1.4.0
	>=dev-php/PEAR-PEAR_PackageFileManager-1.5.2
	>=dev-php/PEAR-VersionControl_SVN-0.3.0_alpha1
	>=dev-php/phpunit-3.2.0
	>=dev-php/xdebug-2.0.0
	>=dev-php/simpletest-1.0.1_beta2 )
	dev-lang/php[xml,xslt]
	"

S=${WORKDIR}/${PN}-${PV/_/}

pkg_postinst() {
	if use minimal; then
		elog "You have enabled the minimal USE flag. If you want to use	features"
		elog "from xdebug, phpunit, simpletest and more, disable the"
		elog "USE flag or emerge the packages manually"
	fi
}
