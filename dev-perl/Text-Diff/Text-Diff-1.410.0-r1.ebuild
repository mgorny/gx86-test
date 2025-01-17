# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=1.41
inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit style"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/Algorithm-Diff"
DEPEND="${RDEPEND}"

SRC_TEST=do
