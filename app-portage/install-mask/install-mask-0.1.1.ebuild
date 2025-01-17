# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="Handle INSTALL_MASK setting in make.conf"
HOMEPAGE="https://bitbucket.org/mgorny/install-mask/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-portage/flaggie[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/portage/config/sets
	newins sets.conf ${PN}.conf
}
