# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
inherit xorg-2 flag-o-matic

DESCRIPTION="query configuration information of DRI drivers"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-proto/glproto"

pkg_setup() {
	xorg-2_pkg_setup

	append-cppflags "-I${EPREFIX}/usr/lib64/opengl/xorg-x11/include/"

}
