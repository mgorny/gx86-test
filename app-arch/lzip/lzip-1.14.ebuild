# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="lossless data compressor based on the LZMA algorithm"
HOMEPAGE="http://www.nongnu.org/lzip/lzip.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
