# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.93
inherit perl-module

DESCRIPTION="XML::LibXML based XML::Simple clone"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/File-Slurp
	>=dev-perl/XML-LibXML-1.640.0
"
DEPEND="${RDEPEND}
"

SRC_TEST=do
