# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit emul-linux-x86

LICENSE="Boost-1.0 LGPL-2.1"
KEYWORDS="-* ~amd64"

IUSE="abi_x86_32"

DEPEND=""
RDEPEND="!abi_x86_32? (
		~app-emulation/emul-linux-x86-baselibs-${PV}
		!>=dev-libs/boost-1.55.0-r2[abi_x86_32(-)]
	)
	abi_x86_32? (
		>=dev-libs/boost-1.55.0-r2[abi_x86_32(-)]
	)"

src_prepare() {
	emul-linux-x86_src_prepare

	# Remove migrated stuff.
	use abi_x86_32 && rm -f usr/lib32/libboost*
}
