# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="Extract ASCII text from a PostScript or PDF file"
HOMEPAGE="http://www.cs.wisc.edu/~ghost/doc/pstotext.htm"
SRC_URI="ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/contrib/${P}.tar.gz"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

DEPEND="app-arch/ncompress"
RDEPEND="app-text/ghostscript-gpl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix bug #132662
	epatch "${FILESDIR}"/${P}-quote-chars-fix.patch
}

src_install () {
	dobin pstotext || die
	doman pstotext.1 || die
}
