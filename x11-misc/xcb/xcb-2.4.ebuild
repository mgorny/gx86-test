# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Marc Lehmann's improved X Cut Buffers"
HOMEPAGE="http://oldhome.schmorp.de/marc/xcb.html"
SRC_URI="http://oldhome.schmorp.de/marc/data/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc x86"
IUSE="motif"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	motif? ( >=x11-libs/motif-2.3:0 )"

src_compile() {
	local gui libs

	if use motif; then
		gui="-DMOTIF"
		libs="-lXm -lXt -lX11"
	else
		gui="-DATHENA"
		libs="-lXaw -lXt -lXext -lX11"
	fi

	tc-export CC
	emake -f Makefile.std xcb Xcb.ad \
		CFLAGS="${CFLAGS} ${gui}" \
		GUI="${gui}" \
		LIBS="${libs}" \
		|| die "emake failed"
}

src_install() {
	dobin xcb || die "dobin failed"
	newman xcb.man xcb.1
	insinto /usr/share/X11/app-defaults
	newins Xcb.ad Xcb || die "newins failed"
}
