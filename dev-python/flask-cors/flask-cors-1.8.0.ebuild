# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="Flask-Cors"
MY_P="${MY_PN}-${PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/wcdolphin/${PN}.git"
	SRC_URI=""
else
	SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="https://github.com/wcdolphin/flask-cors https://pypi.python.org/pypi/Flask-Cors"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		${RDEPEND}
		app-portage/gentoolkit
		|| ( >=dev-python/python-docs-2.7.6-r1 <dev-python/python-docs-3 )
		python_targets_python3_3? ( >=dev-python/python-docs-3.3.5-r1 <dev-python/python-docs-3.4 )
		>=dev-python/python-docs-3.4.0-r1
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	if use doc; then
		local PYTHON_DOC_INVENTORY=$(equery files python-docs | grep objects.inv | tail -n1)
		if [[ -z "${PYTHON_DOC_INVENTORY}" ]]
		then
			die "objects.inv not found in python-docs"
		fi
		PYTHON_DOC="${PYTHON_DOC_INVENTORY%%objects.inv}"
		sed -i "s|'http://docs.python.org/': None|'${PYTHON_DOC}': '${PYTHON_DOC_INVENTORY}'|" docs/conf.py || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
