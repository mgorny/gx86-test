# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_6 python2_7 python3_2 python3_3 )

inherit distutils-r1

DESCRIPTION="Provides Python interfaces for Xen's XenStore"
HOMEPAGE="https://launchpad.net/pyxenstore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-emulation/xen-tools"
RDEPEND="${DEPEND}"
