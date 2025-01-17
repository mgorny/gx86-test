# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Framework for writing simple command-line applications"
HOMEPAGE="http://www.alittletooquiet.net/software/sclapp/"
SRC_URI="http://www.alittletooquiet.net/media/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pexpect[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-testsuite-fix-from-r235.patch"
)

src_test() {
	local DISTUTILS_NO_PARALLEL_BUILD=1

	distutils-r1_src_test
}

python_test() {
	esetup.py test
}
