# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-utils multilib cuda

# change each release, to avoid git in tree dependency
DYND_GIT_SHA1=d230bee7000da1c2b1ab171389df70050fa76e71

DESCRIPTION="C++ dynamic multi-dimensionnal array library with Python exposure"
HOMEPAGE="https://github.com/ContinuumIO/libdynd"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="cuda doc test"

RDEPEND="dev-libs/c-blosc:0=
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-dont-install-test.patch
	"${FILESDIR}"/${PN}-0.6.0-respect-libdir.patch
	"${FILESDIR}"/${PN}-0.6.2-out-of-git-versioning.patch
)

src_prepare() {
	cmake-utils_src_prepare
	# each relase comes with a different set...
	# remove forced strong flags
	sed -i \
		-e "s|@DYND_GIT_SHA1@|${DYND_GIT_SHA1}|" \
		-e "s|@DYND_VERSION@|${PV}|" \
		-e 's|-fomit-frame-pointer||' \
		-e 's|-Werror||g' \
		CMakeLists.txt || die
}

src_configure() {
	sed -i \
		-e '/add_subdirectory(examples)/d' \
		CMakeLists.txt || die
	local mycmakeargs=(
		-DDYND_SHARED_LIB=ON
		-DDYND_INSTALL_LIB=ON
		$(cmake-utils_use cuda DYND_CUDA)
		$(cmake-utils_use test DYND_BUILD_TESTS)
	)
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./tests/test_libdynd || die
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc documents/*
}
