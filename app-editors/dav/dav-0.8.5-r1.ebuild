# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="A minimal console text editor"
HOMEPAGE="http://dav-text.sourceforge.net/"

# The maintainer does not keep sourceforge's mirrors up-to-date,
# so we point to the website's store of files.
SRC_URI="http://dav-text.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-davrc-buffer-overflow.patch
}

src_configure() { :; }

src_compile() {
	emake CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS} -lncurses" \
		CC="$(tc-getCC)" \
		|| die "emake failed"
}

src_install() {
	# no ./configure and doesn't hardcode /usr, so ED is fine
	emake DESTDIR="${ED}" install || die
	dodoc README
}
