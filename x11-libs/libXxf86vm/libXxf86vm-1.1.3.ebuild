# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X.Org Xxf86vm library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-proto/xf86vidmodeproto-2.3.1-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
