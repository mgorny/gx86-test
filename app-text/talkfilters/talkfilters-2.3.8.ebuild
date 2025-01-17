# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Convert ordinary English text into text that mimics a stereotyped or otherwise humorous dialect"
HOMEPAGE="http://www.hyperrealm.com/talkfilters/talkfilters.html"
SRC_URI="http://www.hyperrealm.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README || die
}
