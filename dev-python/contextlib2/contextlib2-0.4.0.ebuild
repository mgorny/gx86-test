# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Backports and enhancements for the contextlib module"
HOMEPAGE="https://pypi.python.org/pypi/contextlib2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

python_test() {
	"${PYTHON}" test_contextlib2.py || die "Tests fail for ${EPYTHON}"
}
