# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A buffered iterator for reading big arrays in small contiguous blocks"
HOMEPAGE="http://pypi.python.org/pypi/arrayterator"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/numpy-1.0_rc1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	cd tests || die

	"${PYTHON}" -c "import test_stochastic; test_stochastic.test()" \
		|| die "Tests fail with ${EPYTHON}"
}
