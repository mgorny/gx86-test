# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

XORG_STATIC=no
XORG_MODULE=data/
inherit xorg-2

DESCRIPTION="X.Org cursor themes: whiteglass, redglass and handhelds"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${RDEPEND}
	x11-apps/xcursorgen"
