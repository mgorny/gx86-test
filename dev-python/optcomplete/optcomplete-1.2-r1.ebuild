# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Shell completion self-generator for Python"
HOMEPAGE="http://furius.ca/optcomplete/ http://pypi.python.org/pypi/optcomplete"
SRC_URI="http://furius.ca/downloads/${PN}/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-linux"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

python_install_all() {
	use examples && local EXAMPLES=( bin/. )
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
