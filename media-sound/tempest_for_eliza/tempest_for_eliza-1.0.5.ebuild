# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="listen to music on the radio generated by images on your screen"
HOMEPAGE="http://www.erikyyy.de/tempest/"
SRC_URI="http://www.erikyyy.de/tempest/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CXX
	econf \
		--enable-debug \
		--enable-nowarnerror
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README

	rm songs/Makefile*
	insinto /usr/share/${PN}
	doins songs/* || die "doins failed"
}
