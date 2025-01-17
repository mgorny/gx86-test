# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="curses-based MSN client"
HOMEPAGE="http://pebrot.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="AUTHORS README PKG-INFO INSTALL ChangeLog COPYING"
PYTHON_MODNAME="pypebrot"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e "s^share/doc/pebrot^share/doc/${PF}^" \
		setup.py pypebrot/pebrot.py || die #241296
}
