# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 MIT"
SLOT="0/11" # subslot = soname major version
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.8"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-uscore.patch
	"${FILESDIR}"/${PN}-multilib-syspath.patch
)

src_configure() {
	local myeconfargs=(
		--disable-padlock-support # bug 201917
		--disable-dependency-tracking
		--enable-noexecstack
		--disable-O-flag-munging
		$(use_enable static-libs static)

		# disabled due to various applications requiring privileges
		# after libgcrypt drops them (bug #468616)
		--without-capabilities

		# http://trac.videolan.org/vlc/ticket/620
		# causes bus-errors on sparc64-solaris
		$([[ ${CHOST} == *86*-darwin* ]] && echo "--disable-asm")
		$([[ ${CHOST} == sparcv9-*-solaris* ]] && echo "--disable-asm")
	)
	autotools-utils_src_configure
}
