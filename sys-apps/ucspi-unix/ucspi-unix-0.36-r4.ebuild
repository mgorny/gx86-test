# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils toolchain-funcs multilib

DESCRIPTION="A ucspi implementation for unix sockets"
HOMEPAGE="http://untroubled.org/ucspi-unix/"
SRC_URI="http://untroubled.org/ucspi-unix/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.106"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gentoo-head.patch
	epatch "${FILESDIR}"/${P}-include-sys_socket.h.patch
	epatch "${FILESDIR}"/${P}-fix-parallel-build.patch
}

src_configure() {
	local has_peercred
	use kernel_linux && has_peercred="-DHASPEERCRED=1"

	echo "$(tc-getCC) ${CFLAGS} -I/usr/include/bglibs ${has_peercred} -D_GNU_SOURCE" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS} -L/usr/$(get_libdir)/bglibs" > conf-ld
}

src_install() {
	dobin unixserver unixclient unixcat || die
	doman unixserver.1 unixclient.1
	dodoc ANNOUNCEMENT NEWS PROTOCOL README TODO
}
