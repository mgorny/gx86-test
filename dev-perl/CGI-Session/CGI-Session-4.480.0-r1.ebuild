# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=4.48
inherit perl-module

DESCRIPTION="persistent session data in CGI applications "

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-CGI-3.26
"
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.380.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Cgi-Simple
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
