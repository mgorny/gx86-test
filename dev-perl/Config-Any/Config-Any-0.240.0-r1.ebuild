# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.24
inherit perl-module

DESCRIPTION="Support several config file formats"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND=">=virtual/perl-Module-Pluggable-3.9
	!<dev-perl/config-general-2.47"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
