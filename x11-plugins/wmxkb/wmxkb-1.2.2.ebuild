# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Dockable keyboard layout switcher for Window Maker"
HOMEPAGE="http://wmalms.tripod.com/#WMXKB"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-proto/inputproto"

src_prepare() {
	sed -i -e 's:$(LD) -o:$(CC) $(LDFLAGS) -o:' Makefile.in || die #336528
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin wmxkb || die #242188

	insinto /usr/share/pixmaps/wmxkb
	doins pixmaps/*.xpm || die

	dodoc CHANGES README || die #350496
	dohtml doc/*.html || die
}
