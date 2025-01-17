# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit eutils distutils-r1

MY_PN=SleekXMPP
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python library for XMPP"
HOMEPAGE="http://sleekxmpp.com/ https://github.com/fritzy/SleekXMPP/"
SRC_URI="https://github.com/fritzy/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="crypt? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

python_test() {
	esetup.py test
}
