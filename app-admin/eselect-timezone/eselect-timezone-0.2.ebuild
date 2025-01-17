# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="Manages timezone selection"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~ottxor/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_install() {
	insinto /usr/share/eselect/modules
	doins timezone.eselect
}
