# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Creates the framework for a new Python project or script"
HOMEPAGE="http://www.seanet.com/~hgg9140/comp/mkpythonproj/doc/index.html"
SRC_URI="http://www.seanet.com/~hgg9140/comp/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="mkproj"

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/*html
	fi
}
