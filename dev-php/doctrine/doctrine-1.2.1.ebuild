# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"
inherit depend.php

MY_P="Doctrine-${PV}"
DESCRIPTION="An object relational mapper for PHP5"
HOMEPAGE="http://www.doctrine-project.org/"
SRC_URI="http://www.doctrine-project.org/downloads/${MY_P}.tgz"

LICENSE="LGPL-2.1 MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.2.3[cli,pdo]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

need_php_by_category

src_install() {
	has_php

	insinto /usr/share/php5/Doctrine
	doins -r lib/*

	dodoc-php CHANGELOG
}
