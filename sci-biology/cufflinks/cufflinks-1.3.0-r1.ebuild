# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Transcript assembly, differential expression, and differential regulation for RNA-Seq"
HOMEPAGE="http://cufflinks.cbcb.umd.edu/"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-biology/samtools-0.1.18
	dev-libs/boost:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-boost.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	)

src_configure() {
	local myeconfargs=(
		--disable-optim
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)/"
		--with-bam="${EPREFIX}/usr/"
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
