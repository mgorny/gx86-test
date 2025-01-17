# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 ) # 2_6 possible with extra deps
inherit distutils-r1

MY_PV=${PV%.*}r${PV##*.}
DESCRIPTION="Backport of Python-3 built-in configparser"
HOMEPAGE="http://pypi.python.org/pypi/configparser/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}
