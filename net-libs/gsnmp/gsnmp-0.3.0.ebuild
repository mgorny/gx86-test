# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit autotools-utils

DESCRIPTION="An SNMP library based on glib and gnet"
HOMEPAGE="http://cnds.eecs.jacobs-university.de/users/schoenw/articles/software/index.html"
SRC_URI="ftp://ftp.ibr.cs.tu-bs.de/pub/local/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux ~ppc x86"
IUSE="static-libs"

DEPEND="
	dev-libs/glib:2
	net-libs/gnet
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-g_access.patch
	"${FILESDIR}"/${P}-underquoting.patch
)

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( README )
