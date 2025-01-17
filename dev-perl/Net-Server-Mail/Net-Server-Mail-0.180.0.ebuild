# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MODULE_AUTHOR=GUIMARD
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="Class to easily create a mail server"

LICENSE="|| ( LGPL-2.1 LGPL-3 )" # LGPL-2.1+
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	virtual/perl-libnet
"
DEPEND="${RDEPEND}
"

SRC_TEST=network
