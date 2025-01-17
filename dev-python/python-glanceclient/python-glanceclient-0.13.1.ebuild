# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Glance API"
HOMEPAGE="https://github.com/openstack/python-glanceclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
REQUIRED_USE="test? ( doc )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.9[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		)
	"
RDEPEND=">=dev-python/pbr-0.6[${PYTHON_USEDEP}]
		!~dev-python/pbr-0.7[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
		<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-0.11[${PYTHON_USEDEP}]
		>=dev-python/warlock-1.0.1[${PYTHON_USEDEP}]
		<dev-python/warlock-2[${PYTHON_USEDEP}]
		>=dev-python/six-1.7.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -e 's:intersphinx_mapping:_&:' -i doc/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	testr init
	testr run || die "testsuite failed under python2.7"
	flake8 tests && einfo "run flake8 over tests folder passed" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
