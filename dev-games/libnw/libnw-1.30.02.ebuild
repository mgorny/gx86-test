# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Tools and libraries for NWN file manipulation"
HOMEPAGE="http://openknights.sourceforge.net/"
SRC_URI="mirror://sourceforge/openknights/${P}.tar.gz"

LICENSE="openknights"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND="!sci-biology/newick-utils"

src_prepare() {
	sed -i \
		-e '/^CC =/d' \
		-e '/^CXX =/d' \
		$(find . -name Makefile.in) \
		|| die "sed failed"
	tc-export CC CXX
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README README.tech TODO
}
