# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Execute code after a scope finished compilation"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~x64-macos"
IUSE=""

RDEPEND="
	>=dev-perl/Module-Implementation-0.50.0
	>=dev-perl/Module-Runtime-0.12.0
	>=dev-perl/Sub-Exporter-Progressive-0.1.6
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.260.0
"

SRC_TEST=do
