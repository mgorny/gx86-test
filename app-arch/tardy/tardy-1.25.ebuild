# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="A tar post-processor"
HOMEPAGE="http://tardy.sourceforge.net/"
SRC_URI="mirror://sourceforge/tardy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/libexplain
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e 's/$(CXX) .* $(CXXFLAGS) -I./\0 -o $@/' \
		-e '/mv \(.*\)\.o \(.*\)\/\1\.o/d' \
		-e '/@sleep 1/d' \
		-e 's#^\(install-man: $(mandir)/man1/tardy.1\).*#\1#' \
		Makefile.in || die
}

src_compile() {
	emake AR="$(tc-getAR)"
}
