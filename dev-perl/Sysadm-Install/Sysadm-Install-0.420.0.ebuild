# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=MSCHILLI
MODULE_VERSION=0.42
inherit perl-module

DESCRIPTION="Typical installation tasks for system administrators"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hammer"

RDEPEND="dev-perl/TermReadKey
	dev-perl/libwww-perl
	>=dev-perl/Log-Log4perl-1.28
	hammer? ( dev-perl/Expect )"
DEPEND="${RDEPEND}"

SRC_TEST="do"
