# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

TEXLIVE_MODULE_CONTENTS="amsfonts bibtex cm dvipdfmx-def enctex etex etex-pkg glyphlist hyph-utf8 ifluatex ifxetex lua-alt-getopt luatex makeindex metafont mflogo mfware misc pdftex plain tcdialog tex texlive-msg-translations texlive-scripts collection-basic
"
TEXLIVE_MODULE_DOC_CONTENTS="amsfonts.doc bibtex.doc cm.doc enctex.doc etex.doc etex-pkg.doc hyph-utf8.doc ifluatex.doc ifxetex.doc lua-alt-getopt.doc luatex.doc makeindex.doc metafont.doc mflogo.doc mfware.doc pdftex.doc tcdialog.doc tex.doc texlive-scripts.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsfonts.source hyph-utf8.source ifluatex.source ifxetex.source mflogo.source "
inherit  texlive-module
DESCRIPTION="TeXLive Essential programs and files"

LICENSE="GPL-2 GPL-1 LPPL-1.3 OFL TeX TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2011
>=dev-tex/luatex-0.70
!<app-text/texlive-core-2009
!<dev-texlive/texlive-latex-2009
!<dev-texlive/texlive-latexrecommended-2009
!!<dev-texlive/texlive-langcjk-2011
"
RDEPEND="${DEPEND} "
PATCHES=( "${FILESDIR}/texmfcnflua.patch" )
TEXLIVE_MODULE_BINSCRIPTS="texmf/scripts/simpdftex/simpdftex texmf/scripts/texlive/rungs.tlu"
