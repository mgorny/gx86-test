# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=CORION
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Framework to automate HTML forms "

SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

DEPEND="dev-perl/Data-Random
	|| (
		( >dev-perl/libwww-perl-6 dev-perl/HTML-Form )
		<dev-perl/libwww-perl-6
	)"
RDEPEND="${DEPEND}"

SRC_TEST="do"
