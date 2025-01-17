# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PHP_EXT_NAME="yaz"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

inherit php-ext-pecl-r2

KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86"

DESCRIPTION="This extension implements a Z39.50 client for PHP using the YAZ toolkit"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/yaz-3.0.2"
RDEPEND="${DEPEND}"

my_conf="--with-yaz=/usr"
