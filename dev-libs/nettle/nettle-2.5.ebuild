# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils autotools

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="http://www.lysator.liu.se/~nisse/archive/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+gmp"

DEPEND="gmp? ( dev-libs/gmp )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "/CFLAGS=/s: -ggdb3::" -i configure.ac || die
	epatch "${FILESDIR}"/${PN}-2.5-missing-libm-link.patch
	sed -i -e 's/solaris\*)/sunldsolaris*)/' configure.ac || die
	eautoreconf
}

src_configure() {
	# --disable-openssl bug #427526
	econf \
		--enable-shared \
		$(use_enable gmp public-key) \
		--disable-openssl
}
