# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="A high-speed character set detection library"
HOMEPAGE="http://www.atheme.org/project/libguess"
SRC_URI="http://distfiles.atheme.org/${P}.tbz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=dev-libs/libmowgli-0.7.0:0"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable examples) \
		|| die "econf failed"
}

src_test() {
	cd src/tests
	make || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}