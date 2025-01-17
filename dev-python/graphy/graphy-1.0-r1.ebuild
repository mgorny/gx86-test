# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

MY_P=${PN}_${PV}

DESCRIPTION="Simple Chart Library for Python"
HOMEPAGE="http://code.google.com/p/graphy/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	# drop Python version (2.4) from shebangs
	find -name '*.py' -exec sed -i -e '1s:python2\.4:python:' {} + \
		|| die "shebang sed failed"
	# clean up
	find graphy/ -name '*.pyc' -delete || die
	find graphy/ -name '.svn' -exec rm -rf {} + || die

	distutils-r1_python_prepare_all
}

python_compile() {
	:
}

python_test() {
	local PYTHONPATH
	mkdir -p "${BUILD_DIR}"/lib || die
	cp -r graphy "${BUILD_DIR}"/lib/ || die
	"${PYTHON}" "${BUILD_DIR}"/lib/graphy/all_tests.py \
		|| die "Tests fail with ${EPYTHON}"
}

python_install() {
	python_domodule graphy
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
