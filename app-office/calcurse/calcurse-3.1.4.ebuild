# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="a text-based calendar and scheduling application"
HOMEPAGE="http://calcurse.org/"
SRC_URI="http://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
CC_LINGUAS=( de en es fr nl pt_BR ru )
IUSE+=" ${CC_LINGUAS[@]/#/linguas_}"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README TODO )
