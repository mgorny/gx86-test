# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit python-any-r1 autotools-utils

DESCRIPTION="Mock hardware devices for creating unit tests"
HOMEPAGE="https://github.com/martinpitt/umockdev/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RDEPEND="virtual/libgudev:=
	virtual/libudev:=
	>=dev-libs/glib-2.32:2"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	app-arch/xz-utils
	virtual/pkgconfig"

RESTRICT="test"
