# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
inherit multilib

DESCRIPTION="Video Quirks database for pm-utils"
HOMEPAGE="http://pm-utils.freedesktop.org/"
SRC_URI="http://pm-utils.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/$(get_libdir)/pm-utils
	doins -r video-quirks || die
}
