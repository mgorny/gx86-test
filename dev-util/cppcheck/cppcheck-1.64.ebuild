# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1 eutils qt4-r2 toolchain-funcs

DESCRIPTION="static analyzer of C/C++ code"
HOMEPAGE="http://cppcheck.sourceforge.net"
SRC_URI="mirror://sourceforge/cppcheck/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="htmlreport qt4"

DEPEND="htmlreport? ( ${PYTHON_DEPS} )
	>=dev-libs/tinyxml2-2
	qt4? ( dev-qt/qtgui:4 )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Do not use bundled tinyxml2
	epatch "${FILESDIR}"/${P}-tinyxml2.patch
}

src_configure() {
	tc-export CXX
	if use qt4 ; then
		pushd gui
		qt4-r2_src_configure
		popd
	fi
}

src_compile() {
	emake \
		CFGDIR="/usr/share/${PN}/cfg" \
		TINYXML="-ltinyxml2"
	if use qt4 ; then
		pushd gui
		qt4-r2_src_compile
		popd
	fi
	if use htmlreport ; then
		pushd htmlreport
		distutils-r1_src_compile
		popd
	fi
}

src_test() {
	emake TINYXML="-ltinyxml2" check
}

src_install() {
	emake install DESTDIR="${D}" TINYXML="-ltinyxml2"
	dodoc readme.txt
	insinto "/usr/share/${PN}/cfg"
	doins cfg/*.cfg
	if use qt4 ; then
		dobin gui/${PN}-gui
		dodoc readme_gui.txt gui/{projectfile.txt,gui.cppcheck}
	fi
	if use htmlreport ; then
		pushd htmlreport
		distutils-r1_src_install
		popd
		find "${D}" -name "*.egg-info" -delete
	fi
}
