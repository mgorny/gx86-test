# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit distutils-r1

MY_PN="WSGIProxy2"

DESCRIPTION="HTTP proxying tools for WSGI apps"
HOMEPAGE="http://pythonpaste.org/wsgiproxy/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/webtest[${PYTHON_USEDEP}]
		dev-python/socketpool[${PYTHON_USEDEP}]
		dev-python/restkit[$(python_gen_usedep python2_7)] )"
# Tests needing restkit are skipped under py3

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build -b html -d _build/doctrees   . _build/html
	fi
}

# this was always possible
python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
