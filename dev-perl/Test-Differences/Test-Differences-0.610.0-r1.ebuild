# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.61
inherit perl-module

DESCRIPTION="Test strings and data structures and show differences if not ok"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc x86"
IUSE="test"

RDEPEND="dev-perl/Text-Diff
	>=virtual/perl-Data-Dumper-2.126.0"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
