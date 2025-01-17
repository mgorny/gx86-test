# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ANDREWF
MODULE_VERSION=2.17
inherit perl-module eutils

DESCRIPTION="Template::Latex - Latex support for the Template Toolkit"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/Template-Toolkit-2.15
	virtual/perl-File-Spec
	virtual/latex-base"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )"

SRC_TEST="do"
PATCHES=( "${FILESDIR}/Makefile.patch" )
