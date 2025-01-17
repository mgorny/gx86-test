# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools eutils fortran-2

MYP=${PN}-4.0

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/metis/index.html"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/OLD/${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
LICENSE="free-noncomm"
IUSE="doc static-libs"

DEPEND=""
RDEPEND="${DEPEND}
	!sci-libs/parmetis"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-autotools.patch \
		"${FILESDIR}"/${P}-gcc44.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES || die "dodoc failed"
	use doc && dodoc Doc/manual.ps
}
