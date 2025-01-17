# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="http://mathema.tician.de/software/pyopencl http://pypi.python.org/pypi/pyopencl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples opengl"

RDEPEND=">=dev-libs/boost-1.48[python]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/pytools[${PYTHON_USEDEP}]
	>=virtual/opencl-0-r1"
DEPEND="${RDEPEND}"

src_configure()
{
	local myconf=()
	if use opengl; then
		myconf+=(--cl-enable-gl)
	fi

	"${PYTHON}" configure.py \
		--boost-compiler=gcc \
		--boost-python-libname=boost_python-${PYTHON_ABI}-mt \
		--no-use-shipped-boost \
		"${myconf[@]}"
}

python_install_all() {
	if use examples; then
		local EXAMPLES=( examples/. )
		einfo "Some of the examples provided by this package require dev-python/matplotlib."
	fi
	distutils-r1_python_install_all
}
