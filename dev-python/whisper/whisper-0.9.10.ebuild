# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Fixed size round-robin style database"
HOMEPAGE="http://graphite.wikidot.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
