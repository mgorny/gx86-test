# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_{6,7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Fixed size round-robin style database"
HOMEPAGE="http://graphite.wikidot.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
