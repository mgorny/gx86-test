# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{3_2,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A Python module for making simple text/console-mode user interfaces"
HOMEPAGE="http://pythondialog.sourceforge.net/"
SRC_URI="mirror://sourceforge/pythondialog//${PV}/python3-${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="examples"

DEPEND="dev-util/dialog"
RDEPEND="${DEPEND}"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
