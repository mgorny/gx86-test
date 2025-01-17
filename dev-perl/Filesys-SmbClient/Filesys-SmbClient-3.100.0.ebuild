# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MODULE_AUTHOR="ALIAN"
MODULE_VERSION=3.1
inherit perl-module

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl
	>=net-fs/samba-3.0.20[smbclient]"
RDEPEND="${DEPEND}"

# tests are not designed to work on a non-developer system.
RESTRICT=test
