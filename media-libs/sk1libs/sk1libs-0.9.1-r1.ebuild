# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="sk1 vector graphics lib"
HOMEPAGE="http://sk1project.org/index.php"
SRC_URI="http://uniconvertor.googlecode.com/files/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"
LICENSE="GPL-2 LGPL-2"
IUSE=""

DEPEND="
	media-fonts/ttf-bitstream-vera
	media-libs/freetype:2
	virtual/jpeg
	>=media-libs/lcms-1.15:0[python]"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	media-libs/netpbm"

src_prepare() {
	distutils_src_prepare
	sed -i -e "/include_dirs/s:\(/usr/include/freetype2\):${EPREFIX}\1:" \
		setup.py || die
}

src_install() {
	distutils_src_install

	font-fixation() {
		local ttf
		for ttf in "${ED}"/$(python_get_sitedir)/sk1libs/ft2engine/fallback_fonts/*.ttf; do
			rm -f "${ttf}" || die
			dosym /usr/share/fonts/ttf-bitstream-vera/$(basename "${ttf}") $(python_get_sitedir)/sk1libs/ft2engine/fallback_fonts/$(basename "${ttf}")
		done
	}
	python_execute_function font-fixation
}
