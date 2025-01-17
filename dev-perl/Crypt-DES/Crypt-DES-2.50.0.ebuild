# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MODULE_AUTHOR=DPARIS
MODULE_VERSION=2.05
inherit perl-module

DESCRIPTION="Crypt::DES module for perl"

LICENSE="DES"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

export OPTIMIZE="${CFLAGS}"
