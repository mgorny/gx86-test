# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="convert python profile data to kcachegrind calltree form"
HOMEPAGE="http://pypi.python.org/pypi/pyprof2calltree/"
SRC_URI="mirror://pypi/p/${PN}/${PF}.tar.gz"
IUSE=

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
