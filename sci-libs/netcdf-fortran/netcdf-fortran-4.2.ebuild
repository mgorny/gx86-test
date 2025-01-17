# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

FORTRAN_STANDARD="77 90"
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/5"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="sci-libs/netcdf"
DEPEND="${RDEPEND}
	dev-lang/cfortran
"

src_prepare() {
	# use system cfortran
	rm fortran/cfortran.h || die
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
