# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-parent"
DEPEND=">=dev-perl/extutils-depends-0.302
	${RDEPEND}"

SRC_TEST=do
