# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Interface to perls parser variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/B-Hooks-OP-Check"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.302
	test? ( dev-perl/Test-Exception
		dev-perl/B-Hooks-EndOfScope )"
SRC_TEST=do
