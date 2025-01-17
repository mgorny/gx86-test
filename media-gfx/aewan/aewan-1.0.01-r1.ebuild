# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils

DESCRIPTION="A curses-based ascii-art editor"
HOMEPAGE="http://aewan.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( CHANGELOG README TODO )

DEPEND="sys-libs/zlib
	>=sys-libs/ncurses-5.0"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-debug_aewl-warnings.patch"
}
