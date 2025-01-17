# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A real IDENT daemon for linux"
HOMEPAGE="http://www.fukt.bth.se/~per/identd"
SRC_URI="http://www.fukt.bth.se/~per/identd/${P}.tar.gz"
IUSE="xinetd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc sparc x86"

DEPEND=""
RDEPEND="xinetd? ( sys-apps/xinetd )"

src_compile() {
	emake CC="$(tc-getCC)" CEXTRAS="${CFLAGS}"
}

src_install() {
	dodir /etc/init.d /usr/sbin /usr/share/man/man8
	dodoc README ChangeLog
	emake install DESTDIR="${D}" MANDIR=/usr/share/man

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/identd.xinetd identd
	else
		newinitd "${FILESDIR}"/identd.init identd
	fi
}
