# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Quotes from George W. Bush"
HOMEPAGE="http://dubya.seiler.us/"
SRC_URI="http://seiler.us/wiki/images/8/8c/Dubya-${PV}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/fortune-mod-/}

src_install() {
	insinto /usr/share/fortune
	doins dubya dubya.dat || die
}
