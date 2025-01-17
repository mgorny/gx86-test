# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5-jython"

inherit distutils

DESCRIPTION="Python 2 and 3 compatibility library"
HOMEPAGE="http://pypi.python.org/pypi/six"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"

DEPEND="doc? ( dev-python/sphinx )"
RDEPEND=""

PYTHON_MODNAME="${PN}.py"

src_compile() {
	distutils_src_compile
	if use doc; then
		cd documentation || die
		emake html
	fi
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r documentation/_build/html/*
	fi
}
