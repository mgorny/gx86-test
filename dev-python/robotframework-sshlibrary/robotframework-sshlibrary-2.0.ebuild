# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A test library for Robot Framework that enables SSH and SFTP"
HOMEPAGE="http://code.google.com/p/robotframework-sshlibrary/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/robotframework[${PYTHON_USEDEP}]"
