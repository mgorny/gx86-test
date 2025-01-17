# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

inherit eutils versionator toolchain-funcs

MY_P="${PN}-$(replace_version_separator 2 -)"
DESCRIPTION="A library of curses widgets"
HOMEPAGE="http://dickey.his.com/cdk/cdk.html"
SRC_URI="ftp://invisible-island.net/cdk/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples"

DEPEND=">=sys-libs/ncurses-5.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${PN}-5.0.20120323-parallel-make.patch
}

src_configure() {
	econf --with-ncurses --with-libtool
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DOCUMENT_DIR="${ED}/usr/share/doc/${MY_P}" install \
		|| die "emake install failed"

	if $(use examples); then
		for x in include c++ demos examples cli cli/utils cli/samples; do
			docinto $x
			find $x -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 dodoc
		done
	fi
}
