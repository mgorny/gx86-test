# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=GARU
MODULE_VERSION=0.36
inherit perl-module

DESCRIPTION="Recursively copy Perl datatypes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

SRC_TEST="do"
mymake='OPTIMIZE=${CFLAGS}'
