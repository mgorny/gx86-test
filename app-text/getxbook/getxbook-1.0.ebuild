# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Download books from google, amazon, barnes and noble"
HOMEPAGE="http://njw.me.uk/software/getxbook/"
SRC_URI="http://njw.me.uk/software/getxbook/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pdf djvu ocr tk"

DEPEND=""
RDEPEND="djvu? ( app-text/djvu )
	pdf? ( media-gfx/imagemagick )
	ocr? ( app-text/tesseract
		pdf? ( media-gfx/exact-image app-text/pdftk ) )
	tk? ( dev-lang/tk )"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	tc-export CXX
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README LEGAL
	exeinto /usr/bin
	use pdf  && doexe extras/mkpdf.sh
	use djvu && doexe extras/mkdjvu.sh
	if use ocr; then
		doexe extras/mkocrtxt.sh
		use pdf  && doexe extras/mkocrpdf.sh
		use djvu && doexe extras/mkocrdjvu.sh
	fi
	use tk && doexe getxbookgui.tcl
}
