# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A Python wrapper for the ALSA API"
HOMEPAGE="http://www.sourceforge.net/projects/pyalsaaudio http://pypi.python.org/pypi/pyalsaaudio"
SRC_URI="mirror://sourceforge/pyalsaaudio/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ~sparc x86"
IUSE="doc"

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6 )"
RESTRICT="test"

DOCS=( CHANGES README )

python_compile() {
	distutils-r1_python_compile

	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" test.py -v
	}
	python_execute_function testing
}

python_install() {
	distutils-r1_python_install

	if use doc; then
		dohtml -r doc/html/
	fi

	insinto /usr/share/doc/${PF}/examples
	doins *test.py
}
