# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

PYTHON_DEPEND="2"
PYTHON_USE_WITH="xml(+)"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="HTML parser based on the HTML5 specification"
HOMEPAGE="http://code.google.com/p/html5lib/ http://pypi.python.org/pypi/html5lib"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
