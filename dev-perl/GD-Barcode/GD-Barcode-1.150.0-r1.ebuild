# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=KWITKNR
MODULE_VERSION=1.15
inherit perl-module

DESCRIPTION="GD::Barcode - Create barcode image with GD"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/GD"
DEPEND="${RDEPEND}"

SRC_TEST="do"
