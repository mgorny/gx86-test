# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

MY_P="Apse-${PV}"

DESCRIPTION="Approximate String Matching in Python"
HOMEPAGE="http://www.personal.psu.edu/staff/i/u/iua1/python/apse/"
SRC_URI="http://www.personal.psu.edu/staff/i/u/iua1/python/${PN}/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-lang/swig:1"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Prevent the build system from calling swig over and over again.
	sed -i -e 's:Apse.i:Apse_wrap.c:' setup.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	set -- swig1.3 -python -o Apse_wrap.c Apse.i
	echo "${@}" >&2
	"${@}" || die
}

python_test() {
	"${PYTHON}" test/test_Apse.py || die "Tests fail with ${EPYTHON}"
}
