# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Succeed or throw exception"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Exception-Died
	>=dev-perl/Exception-Base-0.22.01"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"
#	test? ( >=dev-perl/Test-Unit-Lite-0.12
#		dev-perl/Test-Assert
#		dev-perl/Exception-Warning )"
