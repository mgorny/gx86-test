# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=1.23
inherit perl-module

DESCRIPTION="Interact with a t/test_manifest file"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
