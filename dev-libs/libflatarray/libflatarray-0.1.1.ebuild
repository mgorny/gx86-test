# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-utils cuda

SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"

DESCRIPTION="Struct of arrays library with object oriented interface for C++"
HOMEPAGE="http://www.libgeodecomp.org/libflatarray.html"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="cuda doc"

RDEPEND="
	>=dev-libs/boost-1.48
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with cuda CUDA)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS=( README )
	cmake-utils_src_install
}

src_test() {
	cmake-utils_src_make test
}