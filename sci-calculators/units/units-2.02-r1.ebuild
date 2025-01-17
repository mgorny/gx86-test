# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit autotools eutils

DESCRIPTION="Unit conversion program"
HOMEPAGE="http://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=sys-libs/readline-4.1-r2
"
RDEPEND="
	|| (
		dev-lang/python:2.5[xml]
		dev-lang/python:2.6[xml]
		dev-lang/python:2.7[xml]
	)
	${DEPEND}
"

DOCS=( ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.01-install.patch
	epatch "${FILESDIR}"/${PN}-2.02-UTF8.patch
	eautoreconf
}
