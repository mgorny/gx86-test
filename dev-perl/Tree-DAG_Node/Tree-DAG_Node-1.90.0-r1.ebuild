# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=RSAVAGE
MODULE_VERSION=1.09
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="(Super)class for representing nodes in a tree"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

DEPEND="
	>=virtual/perl-Module-Build-0.380.0
	test? (
		>=dev-perl/Test-Pod-1.440.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"

SRC_TEST="do"
