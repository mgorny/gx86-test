# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3})
inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="http://pypi.python.org/pypi/asciinema http://asciinema.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/requests-1.1.0[${PYTHON_USEDEP}]"
