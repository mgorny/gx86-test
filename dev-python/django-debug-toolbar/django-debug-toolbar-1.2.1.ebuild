# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A configurable set of panels that display debug information"
HOMEPAGE="http://pypi.python.org/pypi/django-debug-toolbar/
	https://github.com/django-debug-toolbar/django-debug-toolbar/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/django-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.1.10[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -e 's:intersphinx_mapping:_&:' -i docs/conf.py || die
	# This prevents distutils from installing 'tests' package, rm magic no more needed
	sed -e "/find_packages/s:'tests':'tests.\*', 'tests':" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	emake test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
