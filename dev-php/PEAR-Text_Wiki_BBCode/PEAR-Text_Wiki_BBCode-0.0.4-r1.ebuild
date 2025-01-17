# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit php-pear-r1

DESCRIPTION="BBCode parser for Text_Wiki"

LICENSE="LGPL-2.1 PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"
RDEPEND=">=dev-php/PEAR-Text_Wiki-1.0.3"
