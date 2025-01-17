# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Object-oriented framework for creating a code generator for Boost.Python library"
HOMEPAGE="http://www.language-binding.net/"

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="http://svn.code.sf.net/p/pygccxml/svn/${PN}_dev"
	inherit subversion
	S=${WORKDIR}/${PN}_dev
else
	SRC_URI="http://dev.gentoo.org/~heroxbd/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="freedist Boost-1.0"
SLOT="0"
IUSE="doc examples numpy"

DEPEND="doc? ( >=dev-python/epydoc-3[${PYTHON_USEDEP}] )
	app-arch/unzip
	numpy? ( dev-python/numpy )"
RDEPEND="dev-python/pygccxml[${PYTHON_USEDEP}]"

src_prepare() {
	use numpy && epatch --binary "${FILESDIR}"/${PN}-1.0.0_p20131206-numpy.patch
}

python_compile_all() {
	use doc && "$(PYTHON)" setup.py doc
}

python_test() {
	"$(PYTHON)" unittests/test_all.py
}

python_install_all() {
	use doc && local HTML_DOCS=(  docs/documentation/apidocs/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
