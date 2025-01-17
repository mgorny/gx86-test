# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

IUSE=""

DESCRIPTION="cputnik is a simple cpu monitor dockapp"
HOMEPAGE="http://clay.ll.pl/projects.html#dockapps"
SRC_URI="http://clay.ll.pl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_compile()
{
	make CFLAGS="${CFLAGS} -Iwmgeneral" || die "Compilation failed"
}

src_install()
{
	dobin cputnik
	dodoc AUTHORS Changelog README
}
