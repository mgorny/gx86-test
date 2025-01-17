# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit xorg-2

DESCRIPTION="Voodoo video driver"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto"
