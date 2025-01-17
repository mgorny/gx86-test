# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-utils udev

DESCRIPTION="Libraries for supporing the BladeRF hardware from Nuand"
HOMEPAGE="http://nuand.com/"

#lib is LGPL and cli tools are GPL
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/${PV}"

#maintainer notes:
#doc use flag, looks like it can't be disabled right now and will
#	always build if pandoc and help2man are installed
#	also ignores when deps are missing and just disabled docs
IUSE="doc +tecla"

MY_PN="bladeRF"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Nuand/${MY_PN}.git"
	KEYWORDS=""
else
	MY_PV=${PV/\_/-}
	S="${WORKDIR}/${MY_PN}-${MY_PN}-${MY_PV}"
	SRC_URI="https://github.com/Nuand/${MY_PN}/archive/${MY_PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

CDEPEND=">=dev-libs/libusb-1.0.16"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	tecla? ( dev-libs/libtecla )"
RDEPEND="${CDEPEND}"
PDEPEND=">=net-wireless/bladerf-firmware-1.7.1
	>=net-wireless/bladerf-fpga-0.0.6"

src_configure() {
	mycmakeargs=(
		-DVERSION_INFO_OVERRIDE:STRING="${PV}"
		$(cmake-utils_use_enable doc BUILD_DOCUMENTATION)
		$(cmake-utils_use_enable tecla LIBTECLA)
		-DTREAT_WARNINGS_AS_ERRORS=OFF
		-DUDEV_RULES_PATH="$(get_udevdir)"/rules.d
	)
	cmake-utils_src_configure
}
