# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit latex-package

DESCRIPTION="LaTeX class for the standard model for curricula vitae as recommended by the European Commission"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/europecv.html"
# Downloaded from:
# ftp://cam.ctan.org/tex-archive/macros/latex/contrib/europecv.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="examples"

RDEPEND="|| ( >=dev-texlive/texlive-latexextra-2008 dev-tex/latex-unicode )"
DEPEND="${RDEPEND}
	app-arch/unzip"
S="${WORKDIR}/${PN}"

TEXMF=/usr/share/texmf-site

src_compile() {
	return
}

src_install() {
	insinto ${TEXMF}/tex/latex/europecv
	doins ecv* europecv.cls EuropeFlag* europasslogo*

	insinto /usr/share/doc/${PF}
	doins -r europecv.pdf europecv.tex
	dosym /usr/share/doc/${PF}/europecv.pdf	${TEXMF}/doc/latex/${PN}/europecv.pdf
	use examples && doins -r examples templates
}
