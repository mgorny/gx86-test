# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit eutils autotools

DESCRIPTION="C-based libraries for the Dirac video codec"
HOMEPAGE="http://www.diracvideo.org/"
SRC_URI="http://www.diracvideo.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="amd64 hppa x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-lang/orc-0.4.16"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc-am"

src_prepare() {
	# from upstream, drop at next release
	epatch "${FILESDIR}"/${P}-darwin-compile.patch

	sed -i \
		-e '/AS_COMPILER_FLAG(-O3/d' \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		configure.ac || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
