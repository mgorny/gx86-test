# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit toolchain-funcs

MY_P=${P/editor}

DESCRIPTION="A file viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="http://hte.sourceforge.net/"
SRC_URI="mirror://sourceforge/hte/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

DOCS=( AUTHORS ChangeLog KNOWNBUGS README TODO )

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable X x11-textmode) \
		--enable-maintainermode
}

src_compile() {
	emake AR="$(tc-getAR)" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	#For prefix
	chmod u+x "${S}/install-sh"

	default

	dohtml doc/*.html
	doinfo doc/*.info
}
