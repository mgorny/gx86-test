# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_3} pypy pypy2_0 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Simple, fast, extensible JSON encoder/decoder for Python"
HOMEPAGE="http://undefined.org/python/#simplejson http://pypi.python.org/pypi/simplejson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT AFL-2.1 )"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

python_compile() {
	if [[ ${EPYTHON} == python2* ]]; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}
