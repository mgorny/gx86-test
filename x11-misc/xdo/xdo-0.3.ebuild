# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Small X utility to perform elementary actions on windows"
HOMEPAGE="https://github.com/baskerville/xdo/"
SRC_URI="https://github.com/baskerville/xdo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libxcb
	x11-libs/xcb-util-wm"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e '/CFLAGS += -Os/d' \
		-e '/LDFLAGS += -s/d' \
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX=/usr
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
}
