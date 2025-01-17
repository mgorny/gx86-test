# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings to the OpenStack Object Storage API"
HOMEPAGE="https://launchpad.net/python-swiftclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pbr[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.4.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.17[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.32[${PYTHON_USEDEP}]
		>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.9[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.2[${PYTHON_USEDEP}] ) )"
RDEPEND=">=dev-python/simplejson-2.0.9[${PYTHON_USEDEP}]
	>=dev-python/requests-1.1[${PYTHON_USEDEP}]"

#PATCHES=( "${FILESDIR}/CVE-2013-6396.patch" )

python_prepare() {
	sed -i '/discover/d' "${S}/test-requirements.txt" || die "sed failed"
	distutils-r1_python_prepare
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	testr init
	testr run || die "tests failed under python2_7"
	flake8 tests && einfo "run of tests folder by flake8 passed"
	flake8 bin/swift && einfo "run of ./bin/swift by flake8 passed"
}

python_install_all() {
	use doc && local HTML_DOCS=( ../${P}-python2_7/doc/build/html/. )
	distutils-r1_python_install_all
}
