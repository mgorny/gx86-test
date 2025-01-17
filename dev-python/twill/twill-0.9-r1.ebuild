# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Simple scripting language for web browsing with Python API"
HOMEPAGE="http://twill.idyll.org/"
SRC_URI="http://darcs.idyll.org/~t/projects/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( $(python_gen_cond_dep 'dev-python/epydoc[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/dnspython[${PYTHON_USEDEP}]' python2_7) )"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		pushd doc > /dev/null
		chmod +x make-epydoc.sh
		./make-epydoc.sh
		popd> /dev/null
	fi
}

python_install_all() {
	use doc && HTML_DOCS=( doc/epydoc-html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
