# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.010
inherit perl-module

DESCRIPTION='Build.PL install path logic made easy'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.30
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
RDEPEND="
	>=dev-perl/ExtUtils-Config-0.2.0
	virtual/perl-File-Spec
"
SRC_TEST="do"
