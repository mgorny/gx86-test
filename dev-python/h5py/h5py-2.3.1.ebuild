# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Simple Python interface to HDF5 files"
HOMEPAGE="http://www.h5py.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test examples mpi"

RDEPEND="
	sci-libs/hdf5:=[mpi=]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	mpi? ( dev-python/mpi4py[${PYTHON_USEDEP}] )"
DISTUTILS_NO_PARALLEL_BUILD=1

pkg_setup() {
	if use mpi ; then
		export CC=mpicc
	fi
}

python_prepare_all() {
	append-cflags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --mpi=$(usex mpi yes no)
}

python_test() {
	esetup.py test --mpi=$(usex mpi yes no)
}

python_install() {
	distutils-r1_python_install --mpi=$(usex mpi yes no)
}

python_install_all() {
	DOCS=( README.rst ANN.rst )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
