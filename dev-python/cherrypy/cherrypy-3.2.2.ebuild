# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
PYTHON_DEPEND="*:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_P="CherryPy-${PV}"

DESCRIPTION="CherryPy is a pythonic, object-oriented HTTP framework"
HOMEPAGE="http://www.cherrypy.org/ http://pypi.python.org/pypi/CherryPy"
SRC_URI="http://download.cherrypy.org/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"

DEPEND="dev-python/setuptools"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare
	sed -i \
		-e 's/"cherrypy.tutorial", //' \
		-e "/('cherrypy\/tutorial',/,/),/d" \
		-e "/LICENSE.txt/d" \
		setup.py || die "sed failed"
}

src_test() {
	distutils_src_test < /dev/tty
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/cherrypy/test"
	}
	python_execute_function -q delete_tests

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r cherrypy/tutorial
	fi
}
