# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Provides enhanced HTTPS support for httplib and urllib2 using PyOpenSSL"
HOMEPAGE="http://ndg-security.ceda.ac.uk/wiki/ndg_httpsclient
	https://pypi.python.org/pypi/ndg-httpsclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~x86-fbsd ~amd64-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="dev-python/pyopenssl[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${P/-/_}"
