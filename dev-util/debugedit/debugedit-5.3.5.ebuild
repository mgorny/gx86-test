# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# To recreate this tarball, just grab latest rpm5 release:
#	http://rpm5.org/files/rpm/
# The files are in tools/
# Or see $FILESDIR/update.sh

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="standalone debugedit taken from rpm"
HOMEPAGE="http://www.rpm5.org/"
SRC_URI="http://dev.gentoo.org/~swegener/distfiles/${P}.tar.bz2
	http://dev.gentoo.org/~vapier/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/popt
	dev-libs/elfutils
	dev-libs/beecrypt"
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin debugedit || die
}
