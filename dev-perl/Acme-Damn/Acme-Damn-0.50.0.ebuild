# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=IBB
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Module, that 'unblesses' Perl objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-perl/Test-Exception )"
RDEPEND=""

PATCHES=( "${FILESDIR}/${PN}-respect-cflags.patch" )

SRC_TEST="do"
