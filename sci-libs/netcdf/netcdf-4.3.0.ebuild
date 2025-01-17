# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+dap doc examples hdf +hdf5 mpi static-libs szip test tools"

RDEPEND="
	dap? ( net-misc/curl )
	hdf? ( sci-libs/hdf <=sci-libs/hdf5-1.8.12:0= )
	hdf5? ( <=sci-libs/hdf5-1.8.12:0=[mpi=,szip=,zlib] )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

REQUIRED_USE="test? ( tools )"

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--disable-examples
		$(use_enable dap)
		$(use_enable doc doxygen)
		$(use_enable hdf hdf4)
		$(use_enable hdf5 netcdf-4)
		$(use_enable tools utilities)
	)
	autotools-utils_src_configure
}

src_test() {
	emake -j1 check
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
