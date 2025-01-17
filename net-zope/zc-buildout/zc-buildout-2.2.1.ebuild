# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="System for managing development buildouts"
HOMEPAGE="http://pypi.python.org/pypi/zc.buildout"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/setuptools-0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}
DOCS=( README.rst doc/tutorial.txt )
# Tests require zope packages absent from portage

src_install() {
	distutils-r1_src_install

	# Remove README.txt installed in incorrect location.
	rm -f "${D}usr/README.txt"
}
