# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=DWHEELER
MODULE_VERSION=3.29
inherit perl-module

DESCRIPTION="Stream TAP from pgTAP test scripts"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="virtual/perl-Test-Harness"
DEPEND="${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		virtual/perl-Module-Build
"

SRC_TEST="do"
