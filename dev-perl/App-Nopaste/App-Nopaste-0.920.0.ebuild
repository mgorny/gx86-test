# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=SARTAK
MODULE_VERSION=0.92
inherit perl-module

DESCRIPTION="Easy access to any pastebin"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+pastebin clipboard github"

DEPEND="
	dev-perl/Class-Load
	dev-perl/Getopt-Long-Descriptive
	dev-perl/JSON
	dev-perl/WWW-Mechanize
	virtual/perl-Module-Pluggable
	dev-perl/URI
	pastebin? (
		dev-perl/WWW-Pastebin-PastebinCom-Create
	)
	clipboard? (
		dev-perl/Clipboard
	)
	github? (
		dev-vcs/git[perl]
	)
"
RDEPEND="${DEPEND}"

SRC_TEST="do"
