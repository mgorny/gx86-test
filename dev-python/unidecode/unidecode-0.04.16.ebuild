# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} pypy pypy2_0 )

MY_PN=Unidecode
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Module providing ASCII transliterations of Unicode text"
HOMEPAGE="http://pypi.python.org/pypi/Unidecode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~sparc ~x86"

S=${WORKDIR}/${MY_P}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test || die "Tests failed under ${EPYTHON}"
}
