# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Matplotlib toolkit for gridding irreguraly spaced data"
HOMEPAGE="http://matplotlib.sourceforge.net/users/toolkits.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-python/matplotlib-0.98[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="mpl_toolkits/natgrid"

python_install_all() {
	insinto /usr/share/doc/${PF}
	doins test.py || die "doins failed"
	distutils-r1_python_install_all
}

python_install() {
	# Fix collision with dev-python/matplotlib.
	rm -f "${D}$(python_get_sitedir)/mpl_toolkits/__init__.py" || die
	distutils-r1_python_install
}
