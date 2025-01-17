# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

MY_P="${P/_rc/-rc}"

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="http://pypi.python.org/pypi/ropemode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/rope-0.9.2"
DEPEND="${DEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"
