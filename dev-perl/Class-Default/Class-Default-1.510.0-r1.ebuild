# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.51
inherit perl-module

DESCRIPTION="Static calls apply to a default instantiation"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.28"

SRC_TEST="do"
