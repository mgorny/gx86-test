# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_{2,3,4}} )

inherit distutils-r1

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="https://launchpad.net/pyflakes http://pypi.python.org/pypi/pyflakes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS NEWS.txt README.rst)

python_test() {
	esetup.py test --quiet
}
