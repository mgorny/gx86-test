# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit scons-utils toolchain-funcs

DESCRIPTION="exFAT filesystem utilities"
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://docs.google.com/uc?export=download&id=0B7CLI-REKbE3bnR2WHowZXNtUVU -> ${P}.tar.gz"

LICENSE="GPL-2+" # COPYING is GPL-2 but ChangeLog says "Relicensed the project from GPLv3+ to GPLv2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc ~x86 ~arm-linux ~x86-linux"
IUSE=""

src_compile() {
	tc-export AR CC RANLIB
	escons CCFLAGS="${CFLAGS} -Wall -std=c99"
}

src_install() {
	dobin dump/dumpexfat label/exfatlabel mkfs/mkexfatfs fsck/exfatfsck
	dosym mkexfatfs /usr/bin/mkfs.exfat
	dosym exfatfsck /usr/bin/fsck.exfat

	doman */*.8
	dodoc ChangeLog
}
