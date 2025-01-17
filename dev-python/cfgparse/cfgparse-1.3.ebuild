# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Config File parser for Python"
HOMEPAGE="http://cfgparse.sourceforge.net http://pypi.python.org/pypi/cfgparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="README.txt docs/cfgparse.pdf"
PYTHON_MODNAME="cfgparse.py"
