# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

inherit xorg-2

DESCRIPTION="X rendering operation stress test utility"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}"
