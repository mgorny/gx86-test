# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

TEXLIVE_MODULE_CONTENTS="aichej amsrefs apacite apalike2 beebe bibarts biber bibexport bibhtml biblatex biblatex-apa biblatex-chem biblatex-chicago biblatex-dw biblatex-historian biblatex-ieee biblatex-mla biblatex-nature biblatex-philosophy biblatex-science biblist bibtopic bibtopicprefix bibunits breakcites cell chbibref chicago chicago-annote chembst collref compactbib custom-bib din1505 dk-bib doipubmed fbs figbib footbib harvard harvmac historische-zeitschrift ijqc inlinebib iopart-num jneurosci jurabib listbib logreq margbib multibib munich notes2bib perception pnas2009 rsc showtags sort-by-letters splitbib uni-wtal-ger urlbst collection-bibtexextra
"
TEXLIVE_MODULE_DOC_CONTENTS="amsrefs.doc apacite.doc bibarts.doc biber.doc bibexport.doc bibhtml.doc biblatex.doc biblatex-apa.doc biblatex-chem.doc biblatex-chicago.doc biblatex-dw.doc biblatex-historian.doc biblatex-ieee.doc biblatex-mla.doc biblatex-nature.doc biblatex-philosophy.doc biblatex-science.doc biblist.doc bibtopic.doc bibtopicprefix.doc bibunits.doc breakcites.doc cell.doc chbibref.doc chicago-annote.doc chembst.doc collref.doc custom-bib.doc din1505.doc dk-bib.doc doipubmed.doc figbib.doc footbib.doc harvard.doc harvmac.doc historische-zeitschrift.doc ijqc.doc inlinebib.doc iopart-num.doc jneurosci.doc jurabib.doc listbib.doc logreq.doc margbib.doc multibib.doc munich.doc notes2bib.doc perception.doc rsc.doc showtags.doc sort-by-letters.doc splitbib.doc uni-wtal-ger.doc urlbst.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsrefs.source apacite.source bibarts.source biber.source bibexport.source bibtopic.source bibtopicprefix.source bibunits.source chembst.source collref.source custom-bib.source dk-bib.source doipubmed.source footbib.source harvard.source jurabib.source listbib.source margbib.source multibib.source notes2bib.source rsc.source splitbib.source urlbst.source "
inherit  texlive-module
DESCRIPTION="TeXLive Extra BibTeX styles"

LICENSE="GPL-2 Artistic GPL-1 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2011
!=dev-texlive/texlive-latexextra-2007*
!<dev-texlive/texlive-latex-2009
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/bibexport/bibexport.sh"
