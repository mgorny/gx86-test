# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="a command-line utility for converting 24/32-bit PNG images to paletted (8-bit) PNGs"
HOMEPAGE="http://pngquant.org/"
SRC_URI="http://pngquant.org/${P}-src.tar.bz2"

LICENSE="HPND rwpng"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="debug openmp sse2"

RDEPEND="media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND=${RDEPEND}

src_prepare() {
	# Failure in upstream logic. Otherwise we lose the -I and -L flags
	# from Makefile.
	sed -i \
		-e 's:CFLAGS ?=:CFLAGS +=:' \
		-e 's:LDFLAGS ?=:LDFLAGS +=:' \
		Makefile || die
}

src_compile() {
	use debug || append-cflags -DNDEBUG
	use sse2 && append-cflags -DUSE_SSE=1

	local openmp
	if use openmp && tc-has-openmp; then
		append-cflags -fopenmp
		openmp="-lgomp"
	fi

	tc-export CC
	emake CFLAGSOPT="" OPENMPFLAGS="${openmp}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc CHANGELOG README.md
}
