# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit python-r1

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI="http://www.mpagano.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.3.0.8-r2
	>=sys-apps/portage-2.2.8-r1[${PYTHON_USEDEP}]"

src_install() {
	python_foreach_impl python_doscript ${PN}
	doman *.[0-9]
}
