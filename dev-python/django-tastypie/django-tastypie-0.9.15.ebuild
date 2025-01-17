# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A flexible and capable API layer for django utilising serialisers"
HOMEPAGE="http://pypi.python.org/pypi/django-tastypie/ https://github.com/toastdriven/django-tastypie"
SRC_URI="https://github.com/toastdriven/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="bip doc digest lxml oauth test yaml"

LICENSE="BSD"
SLOT="0"

RDEPEND=">=dev-python/mimeparse-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/django-1.3[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	bip? ( dev-python/biplist[${PYTHON_USEDEP}] )
	digest? ( dev-python/python-digest[${PYTHON_USEDEP}] )
	oauth? ( dev-python/oauth2[${PYTHON_USEDEP}]
		dev-python/django-oauth-plus[${PYTHON_USEDEP}] )
	lxml? ( dev-python/lxml[${PYTHON_USEDEP}] )
	yaml? ( dev-python/pyyaml[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/django-oauth-plus[${PYTHON_USEDEP}]
		dev-python/oauth2[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/python-digest[${PYTHON_USEDEP}]
		dev-python/biplist[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/mimeparse-0.1.3[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/runtests.patch )

python_compile_all() {
	use doc && emake -C docs html
}

src_test() {
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}

python_test() {
	PYTHONPATH=.:tests ./tests/run_all_tests.sh || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
