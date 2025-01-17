# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
PYTHON_DEPEND=2

inherit distutils

DESCRIPTION="URL shortening command line application that supports various sites"
HOMEPAGE="http://launchpad.net/surl"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV%.*}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	distutils_src_install

	dodoc AUTHORS.txt || die "doc install failed"
}
