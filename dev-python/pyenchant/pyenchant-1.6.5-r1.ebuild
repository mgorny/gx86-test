# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Enchant spellchecking system"
HOMEPAGE="http://pyenchant.sourceforge.net http://pypi.python.org/pypi/pyenchant"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
	>=app-text/enchant-${PV%.*}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( README.txt TODO.txt )
PATCHES=( "${FILESDIR}/${PN}-setup.patch" )

python_test() {
	if [[ -n "$(LC_ALL="en_US.UTF-8" bash -c "" 2>&1)" ]]; then
		ewarn "Disabling tests due to missing en_US.UTF-8 locale"
	else
		esetup.py test
	fi
}
