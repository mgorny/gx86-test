# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit python-r1

DESCRIPTION="A virtual for pmw, for Python 2 & 3"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep 'dev-python/pmw:py2[${PYTHON_USEDEP}]' python2*)
	$(python_gen_cond_dep 'dev-python/pmw:py3[${PYTHON_USEDEP}]' python3*)"
