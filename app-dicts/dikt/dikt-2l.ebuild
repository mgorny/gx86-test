# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base

DESCRIPTION="A dictionary for KDE"
HOMEPAGE="http://code.google.com/p/dikt/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.txz -> ${P}.tar.xz"

LICENSE="BSD-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( README )
