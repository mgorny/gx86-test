# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=NUFFIN
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Get weak or strong random data from pluggable sources"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Any-Moose-0.11
	>=dev-perl/Capture-Tiny-0.08
	dev-perl/Module-Find
	dev-perl/Sub-Exporter
	>=dev-perl/namespace-clean-0.08
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-use-ok
	)"

SRC_TEST="do"
