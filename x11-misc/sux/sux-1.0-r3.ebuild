# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="\"su\" wrapper which transfers X credentials"
HOMEPAGE="http://fgouget.free.fr/sux/sux-readme.shtml"
SRC_URI="http://fgouget.free.fr/sux/sux"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc sparc x86"
IUSE=""

S="${WORKDIR}"

DEPEND="sys-apps/debianutils"
RDEPEND="x11-apps/xauth"

src_unpack() {
	cp "${DISTDIR}/${A}" .
	epatch "${FILESDIR}/${P}-r1.patch"
	epatch "${FILESDIR}/${PN}-X11R6.patch"
}

src_compile() {
	echo "nothing to be done"
}

src_install() {
	exeinto /usr/bin
	doexe sux
}
