# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit flag-o-matic multilib

DESCRIPTION="Console-mode amateur radio contest logger"
HOMEPAGE="http://home.iae.nl/users/reinc/TLF-0.2.html"
SRC_URI="mirror://github/Tlf/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	dev-libs/glib:2
	media-libs/hamlib
	media-sound/sox"
DEPEND="${RDEPEND}"

src_configure() {
	append-ldflags -L/usr/$(get_libdir)/hamlib
	econf --docdir=/usr/share/doc/${PF} --enable-hamlib
}
