# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# For python3_{2,3}, see bugs 501338, 501340

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="http://eyed3.nicfit.net/"
SRC_URI="http://eyed3.nicfit.net/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="!<${CATEGORY}/${PN}-0.6.18-r1:0"
DEPEND="${RDEPEND}
	dev-python/paver[${PYTHON_USEDEP}]"

python_install_all() {
	dodoc AUTHORS ChangeLog README.rst
	distutils-r1_python_install_all
}
