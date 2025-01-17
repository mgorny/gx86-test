# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit netsurf

DESCRIPTION="CSS parser and selection engine, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libcss/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="test"

RDEPEND=">=dev-libs/libparserutils-0.1.2[static-libs?,${MULTILIB_USEDEP}]
	>=dev-libs/libwapcaplet-0.2.0[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"
