# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-utils multibuild

DESCRIPTION="Qt API for storing passwords securely"
HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"
SRC_URI="https://github.com/frankosterfeld/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
	)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
	)
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"

DOCS=( ChangeLog ReadMe.txt )

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	if use qt4; then
		MULTIBUILD_VARIANTS+=(qt4)
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=(qt5)
	fi
}

src_configure() {
	myconfigure() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			local mycmakeargs=(-DBUILD_WITH_QT4=ON)
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			local mycmakeargs=(-DBUILD_WITH_QT4=OFF)
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}
