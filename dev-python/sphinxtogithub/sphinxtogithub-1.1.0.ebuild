# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="A python script for preparing the html output of Sphinx documentation for github pages"
HOMEPAGE="http://github.com/michaeljones/sphinx-to-github/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=dev-python/sphinx-1.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Req'd to avoid file collisions
	sed -e s":find_packages():find_packages(exclude=['tests']):" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
