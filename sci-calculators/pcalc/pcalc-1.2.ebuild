# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="the programmers calculator"
HOMEPAGE="http://pcalc.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcalc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog EXAMPLE README
}
