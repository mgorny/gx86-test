# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python code static checker"
HOMEPAGE="http://www.logilab.org/project/pylint http://pypi.python.org/pypi/pylint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples test"

RDEPEND=">=dev-python/logilab-common-0.53.0[${PYTHON_USEDEP}]
	~dev-python/astroid-1.2.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( "${RDEPEND}" )"

PATCHES=( "${FILESDIR}"/${PN}-0.26.0-gtktest.patch )

# Usual. Requ'd for impl specific failures in test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	# selection of straight html triggers a trivial annoying bug, we skirt it
	use doc && emake -C doc singlehtml
}

python_test() {
	# Test suite appears not to work under Python 3.
	# https://bitbucket.org/logilab/pylint/issue/240/
	local msg="Test suite broken with ${EPYTHON}"
	if [[ "${EPYTHON}" == python3* ]]; then
		einfo "${msg}"
		return 0
	fi

	pytest || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	doman man/{pylint,pyreverse}.1
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( doc/_build/singlehtml/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	# Optional dependency on "tk" USE flag would break support for Jython.
	elog "pylint-gui script requires dev-lang/python with \"tk\" USE flag enabled."
}
