# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs versionator

MY_P="${PN}$(replace_all_version_separators '')"
DESCRIPTION="LZMA Stream Compressor from the SDK"
HOMEPAGE="http://www.7-zip.org/sdk.html"
SRC_URI="mirror://sourceforge/sevenzip/${MY_P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~mips ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

S=${WORKDIR}

src_compile() {
	cd CPP/7zip/Compress/LZMA_Alone
	emake -f makefile.gcc \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		CXX_C="$(tc-getCC) ${CFLAGS}" \
		|| die "Make failed"
}

src_install() {
	newbin CPP/7zip/Compress/LZMA_Alone/lzma lzma_alone || die
	dodoc history.txt
	use doc && dodoc 7zC.txt 7zFormat.txt lzma.txt Methods.txt

	einfo "Starting from app-arch/lzma version 4.63 binary name was changed"
	einfo "to /usr/bin/lzma_alone to avoid conflict with lzma-utils package"
}
