# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=DANKOGAI
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Adds encoding() to HTTP::Response"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-perl/libwww-perl"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
