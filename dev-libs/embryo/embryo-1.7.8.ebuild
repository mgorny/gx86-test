# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit enlightenment

DESCRIPTION="load and control programs compiled in embryo language (small/pawn variant)"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2 ZLIB"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/eina-1.7.8"
RDEPEND=${DEPEND}
