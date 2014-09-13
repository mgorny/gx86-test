# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Bytecode optimisation using staticness assertions"
HOMEPAGE="https://github.com/rfk/promise/ http://pypi.python.org/pypi/promise"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="ChangeLog.txt README.txt"

src_test() {
	# Timing tests fail.
	PROMISE_SKIP_TIMING_TESTS="1" distutils_src_test
}
