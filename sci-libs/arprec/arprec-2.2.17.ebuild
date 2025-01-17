# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="90"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils fortran-2 autotools-utils

DESCRIPTION="Arbitrary precision float arithmetics and functions"
HOMEPAGE="http://crd.lbl.gov/~dhbailey/mpdist/"
SRC_URI="http://crd.lbl.gov/~dhbailey/mpdist/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fma fortran qd static-libs"

DEPEND="qd? ( sci-libs/qd:0=[fortran=] )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		$(use_enable fma)
		$(use_enable fortran)
		$(use_enable qd)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use fortran && autotools-utils_src_compile toolkit
}

src_install() {
	autotools-utils_src_install
	if use fortran; then
		cd toolkit
		./mathinit || die "mathinit failed"
		exeinto /usr/libexec/${PN}
		doexe .libs/mathtool
		insinto /usr/libexec/${PN}
		doins *.dat
		echo > mathtool.exe "#!${EROOT%/}/bin/sh"
		echo >> mathtool.exe "cd ${EROOT%/}/usr/libexec/arprec && exec ./mathtool"
		newbin mathtool.exe mathtool
		newdoc README README.mathtool
	fi
	use doc || rm "${ED}"/usr/share/doc/${PF}/*.pdf
}
