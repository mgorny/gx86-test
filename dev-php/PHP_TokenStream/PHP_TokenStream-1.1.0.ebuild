# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="PHP_TokenStream"
inherit php-pear-lib-r1

DESCRIPTION="Wrapper around PHP's tokenizer extension"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de"

DEPEND=">=dev-php/pear-1.9.4"
RDEPEND="${DEPEND}"
