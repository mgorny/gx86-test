# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=DOY
MODULE_VERSION=0.30
inherit perl-module

DESCRIPTION="Visitor style traversal of Perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Load-0.60.0
	>=dev-perl/Moose-0.890.0
	>=dev-perl/namespace-clean-0.190.0
	>=dev-perl/Tie-ToObject-0.01
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Requires
	)
"

SRC_TEST="do"
