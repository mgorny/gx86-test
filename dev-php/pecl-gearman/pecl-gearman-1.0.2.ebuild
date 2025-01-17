# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
PHP_EXT_NAME="gearman"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-3 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension for using gearmand"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND=">=sys-cluster/gearmand-0.21"
RDEPEND="${DEPEND}"
