# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

MY_PN=tables
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Hierarchical datasets for Python"
HOMEPAGE="http://www.pytables.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
IUSE="doc examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	app-arch/bzip2:0=
	dev-libs/c-blosc:0=
	dev-libs/lzo:2=
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/numexpr[${PYTHON_USEDEP}]
	sci-libs/hdf5:0="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( ANNOUNCE.txt RELEASE_NOTES.txt THANKS )

python_prepare_all() {
	export HDF5_DIR="${EPREFIX}"/usr
	sed -i -e "s:/usr:${EPREFIX}/usr:g" setup.py || die
	rm -r c-blosc/{blosc,internal-complibs} || die
	distutils-r1_python_prepare_all
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${EPYTHON} tables/tests/test_all.py || die
}

python_install_all() {
	if use doc; then
		HTML_DOCS=( doc/html/. )
		DOCS+=( doc/scripts )
	fi
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		doins -r contrib
	fi
}
