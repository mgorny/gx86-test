# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools eutils autotools-multilib

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="http://fribidi.org/"
SRC_URI="http://fribidi.org/download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RESTRICT="test" #397347

RDEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r10
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README ChangeLog THANKS TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.19.2-nodoc.patch \
		"${FILESDIR}"/${P}-page-size-header.patch

	# Fix compability with dev-libs/glib >= 2.31
	sed -i \
		-e '/include/s:<glib/gstrfuncs.h>:<glib.h>:' \
		-e '/include/s:<glib/gmem.h>:<glib.h>:' \
		charset/fribidi-char-sets.c lib/mem.h || die

	autotools-multilib_src_prepare
}

src_configure() {
	# --with-glib=yes is required for #345621 to ensure "Requires: glib-2.0" is
	# present in /usr/lib/pkgconfig/fribidi.pc
	local myeconfargs=( --with-glib=yes )
	autotools-multilib_src_configure
}
