# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MODULE_AUTHOR=ANDREWF
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="POD Object Model"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="
	test? (
		dev-perl/Test-Differences
		>=dev-perl/yaml-0.67
		dev-perl/File-Slurp
	)"

SRC_TEST=do
