# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit php-pear-r1

DESCRIPTION="Common file and directory routines"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"
