# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MY_PN=Class-Loader
MODULE_AUTHOR=VIPUL
MODULE_VERSION=2.03
inherit perl-module

DESCRIPTION="Load modules and create objects on demand"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST=do
