# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ALEXP
MODULE_VERSION=1.69
inherit perl-module

DESCRIPTION="Current list of available top level domain names including new ICANN additions and ccTLDs"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc ppc64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
