# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Library to implement a well-behaved Unix daemon process"
HOMEPAGE="http://pypi.python.org/pypi/python-daemon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

RDEPEND=">=dev-python/lockfile-0.9[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/minimock[${PYTHON_USEDEP}] )"

DOCS=( ChangeLog )

python_test() {
	esetup.py test
}
