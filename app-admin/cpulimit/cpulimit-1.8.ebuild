# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Limits the CPU usage of a process"
HOMEPAGE="http://cpulimit.sourceforge.net"
SRC_URI="mirror://sourceforge/limitcpu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	tc-export CC
	# set correct VERSION
	sed -i -e '/^#define VERSION/s/1.7/1.8/' cpulimit.c || die 'sed on VERSION string failed'
}

src_install() {
	dosbin ${PN}
	doman "${FILESDIR}/${PN}.8"
}
