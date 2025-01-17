# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit multilib toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="http://www.keplerproject.org/luafilesystem/"
SRC_URI="http://luaforge.net/frs/download.php/3931/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/lua-5.1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|-O2|${CFLAGS}|" \
		-e "s|gcc|$(tc-getCC)|" \
		config || die
}

src_install() {
	emake PREFIX="${D}usr" install || die
	dodoc README
	dohtml doc/us/*
}
