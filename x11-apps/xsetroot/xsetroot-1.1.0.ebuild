# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

inherit xorg-2

DESCRIPTION="X.Org xsetroot application"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND="x11-libs/libXmu
	x11-libs/libX11
	x11-misc/xbitmaps
	x11-libs/libXcursor"
DEPEND="${RDEPEND}"
