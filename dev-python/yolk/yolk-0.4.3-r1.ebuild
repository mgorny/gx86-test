# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Tool and library for querying PyPI and locally installed Python packages"
HOMEPAGE="http://pypi.python.org/pypi/yolk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-python/setuptools
	dev-python/yolk-portage"
RDEPEND="${DEPEND}"

python_install_all() {
	if use examples; then
		docinto examples/plugins
		dodoc -r examples/plugins/*
	fi
}
