# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Shell completion self-generator for Python"
HOMEPAGE="http://furius.ca/optcomplete/ http://pypi.python.org/pypi/optcomplete"
SRC_URI="http://furius.ca/downloads/${PN}/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-linux"
IUSE="examples"

DEPEND=""
RDEPEND=""

DOCS="CHANGES"
PYTHON_MODNAME="optcomplete.py"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins bin/* || die "doins failed"
	fi
}
