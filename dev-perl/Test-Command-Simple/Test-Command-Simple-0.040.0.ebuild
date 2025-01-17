# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

MODULE_AUTHOR="DMCBRIDE"
MODULE_VERSION=0.04

inherit perl-module

DESCRIPTION="Test external commands (nearly) as easily as loaded modules"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="virtual/perl-Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"
RDEPEND=""

SRC_TEST="do"
