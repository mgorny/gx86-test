# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
PHP_EXT_NAME="eio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CREDITS EXPERIMENTAL INSTALL README LICENSE"

USE_PHP="php5-3 php5-4 php5-5"
inherit php-ext-pecl-r2 confutils eutils

KEYWORDS="~amd64 ~x86"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libeio library"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

IUSE="debug"

src_configure() {
	my_conf="--with-eio"
	enable_extension_enable "eio-debug" "debug" 0

	php-ext-source-r2_src_configure
}
