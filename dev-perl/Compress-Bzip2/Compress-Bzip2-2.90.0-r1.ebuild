# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_VERSION=2.09
MODULE_AUTHOR=ARJAY
inherit perl-module

DESCRIPTION="A Bzip2 perl module"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~mips sparc x86 ~ppc-aix"
IUSE=""

RDEPEND="app-arch/bzip2"
DEPEND="${RDEPEND}"

SRC_TEST="do"
