# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.007
inherit perl-module

DESCRIPTION='A wrapper for perl'\''s configuration'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DEPEND="
	${RDEPEND}
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.88
	)
"
RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.30
	virtual/perl-Data-Dumper
"
SRC_TEST="do"
