# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A tool to generate a static blog, with restructured text (or markdown) input files"
HOMEPAGE="http://pelican.notmyidea.org/ http://pypi.python.org/pypi/pelican"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples markdown"

DEPEND="dev-python/feedgenerator[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	markdown? ( dev-python/markdown[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( README.rst )

python_install_all() {
	use examples && local EXAMPLES=( samples/. )
	distutils-r1_python_install_all
}

# no tests: tests/content not in tarball for 2.8.1
# for 3.0, should be based on tox (refer to virtualenvwrapper)
