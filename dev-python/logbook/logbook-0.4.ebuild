# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN=${PN/l/L}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A logging replacement for Python"
HOMEPAGE="http://packages.python.org/Logbook/ http://pypi.python.org/pypi/Logbook"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="CHANGES README"

S=${WORKDIR}/${MY_P}
