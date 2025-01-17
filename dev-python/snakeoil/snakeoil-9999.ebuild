# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="git://github.com/pkgcore/snakeoil.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="http://snakeoil.googlecode.com/files/${P}.tar.bz2"
fi

DESCRIPTION="Miscellaneous python utility code"
HOMEPAGE="http://snakeoil.googlecode.com/"

LICENSE="BSD"
SLOT="0"

DEPEND="!<sys-apps/pkgcore-0.4.7.8"
RDEPEND=${DEPEND}

python_configure_all() {
	# disable snakeoil 2to3 caching
	unset PY2TO3_CACHEDIR
}

python_test() {
	esetup.py test
}
