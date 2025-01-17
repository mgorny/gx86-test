# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="pure-Python library for parsing and analyzing ELF files and DWARF debugging information"
HOMEPAGE="http://pypi.python.org/pypi/pyelftools https://bitbucket.org/eliben/pyelftools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples"

PATCHES=(
	"${FILESDIR}"/${P}-grace-string-dyn.patch
	"${FILESDIR}"/${P}-dyntable.patch
)

python_test() {
	# readelf_tests often fails due to host `readelf` changing output format
	local t
	for t in all_unittests examples_test ; do
		"${PYTHON}" ./test/run_${t}.py || die "Tests fail with ${EPYTHON}"
	done
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
