# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Skype API"
HOMEPAGE="https://github.com/awahlig/skype4py http://pypi.python.org/pypi/Skype4Py/"
SRC_URI="https://github.com/awahlig/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-im/skype
	|| ( dev-python/dbus-python[${PYTHON_USEDEP}] x11-libs/libX11 )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( CHANGES.rst README.rst )
