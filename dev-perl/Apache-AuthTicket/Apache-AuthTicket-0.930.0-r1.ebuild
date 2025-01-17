# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=MSCHOUT
MODULE_VERSION=0.93
inherit perl-module

DESCRIPTION="Cookie based access module"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )" # GPL-1+
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Apache-AuthCookie-3.0
	dev-perl/DBI
	virtual/perl-Digest-MD5
	dev-perl/SQL-Abstract"
DEPEND="${RDEPEND}"

SRC_TEST="do"
