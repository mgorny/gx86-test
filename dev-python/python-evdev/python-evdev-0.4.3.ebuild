# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="http://gvalkov.github.com/python-evdev/"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
