# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit base bsdmk

DESCRIPTION="pidof(1) utility for *BSD"
HOMEPAGE="http://people.freebsd.org/~novel/pidof.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-freebsd/freebsd-mk-defs"
RDEPEND="!sys-process/psmisc"

S="${WORKDIR}/pidof"

PATCHES=( "${FILESDIR}/${P}-gfbsd.patch"
	"${FILESDIR}/${P}-firstarg.patch"
	"${FILESDIR}/${P}-pname.patch" )

src_install() {
	into /
	dobin pidof
}
