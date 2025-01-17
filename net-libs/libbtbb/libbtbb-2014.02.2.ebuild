# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit multilib cmake-utils

DESCRIPTION="A library to decode Bluetooth baseband packets"
HOMEPAGE="http://libbtbb.sourceforge.net/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/libbtbb.git"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV=${PV/\./-}
	MY_PV=${MY_PV/./-R}
	S=${WORKDIR}/${PN}-${MY_PV}
	SRC_URI="https://github.com/greatscottgadgets/${PN}/archive/${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="+pcap +wireshark-plugins"

RDEPEND="
	wireshark-plugins? (
		dev-libs/glib
		>=net-analyzer/wireshark-1.8.3-r1:=
	)
"
DEPEND="${RDEPEND}
	wireshark-plugins? ( virtual/pkgconfig )"

get_PV() { local pv=$(best_version $1); pv=${pv#$1-}; pv=${pv%-r*}; pv=${pv//_}; echo ${pv}; }

src_prepare(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_prepare

	if use wireshark-plugins; then
		for i in btbb btle btsm
		do
			sed -i 's#column_info#packet#' wireshark/plugins/${i}/cmake/FindWireshark.cmake || die
			CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_prepare
		done
	fi
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	local mycmakeargs=(
	-DDISABLE_PYTHON=true
	-DPACKAGE_MANAGER=true
	$(cmake-utils_use pcap PCAPDUMP)
	)
	cmake-utils_src_configure

	if use wireshark-plugins; then
		for i in btbb btle btsm
		do
			CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			BUILD_DIR="${WORKDIR}"/${i}_build
			local mycmakeargs=(
			-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)/wireshark/plugins/$(get_PV net-analyzer/wireshark)"
			)
			cmake-utils_src_configure
		done
	fi
}

src_compile(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_compile

	if use wireshark-plugins; then
		for i in btbb btle btsm
		do
			CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_compile
		done
	fi
}

src_test(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_test

	if use wireshark-plugins; then
		for i in btbb btle btsm
		do
			CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_test
		done
	fi
}

src_install(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_install

	if use wireshark-plugins; then
		for i in btbb btle btsm
		do
			CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_install
		done
	fi
}
