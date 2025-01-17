# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit flag-o-matic multilib toolchain-funcs java-pkg-2

DESCRIPTION="NativeBigInteger libs for Freenet taken from i2p"
HOMEPAGE="http://www.i2p2.de"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/gmp
	>=virtual/jdk-1.4"
RDEPEND="dev-libs/gmp"

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake libjbigi || die
	use x86 && filter-flags -fPIC -nopie
	emake libjcpuid || die
}

src_install() {
	emake DESTDIR="${D}" LIBDIR=$(get_libdir) install || die
}
