# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=${P/_rc/rc}
DESCRIPTION="A library containing some useful snippets"
HOMEPAGE="http://pypi.python.org/pypi/hcs_utils"
SRC_URI="mirror://pypi/h/${PN/-/_}/${MY_P/-/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND=""

S="${WORKDIR}/${MY_P/-/_}"

python_test() {
	pushd  "${BUILD_DIR}/lib" > /dev/null
	py.test --doctest-modules hcs_utils || die "Tests failed"
}
