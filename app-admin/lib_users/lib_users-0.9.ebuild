# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit python-r1

DESCRIPTION="Checks /proc for libraries being mapped but marked as deleted"
HOMEPAGE="http://schwarzvogel.de/software-misc.shtml"
SRC_URI="http://schwarzvogel.de/pkgs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="${PYTHON_DEPS}"

src_test() {
	python_foreach_impl nosetests --verbosity=2
}

src_install() {
	python_foreach_impl python_newscript lib_users.py lib_users
	dodoc README TODO
}
