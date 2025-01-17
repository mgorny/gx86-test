# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-polish cc-pl gustlib gustprog hyphen-polish lshort-polish mex mwcls pl polski przechlewski-book qpxqtx tap tex-virtual-academy-pl texlive-pl utf8mex collection-langpolish
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-polish.doc cc-pl.doc gustlib.doc gustprog.doc lshort-polish.doc mex.doc mwcls.doc pl.doc polski.doc przechlewski-book.doc qpxqtx.doc tap.doc tex-virtual-academy-pl.doc texlive-pl.doc utf8mex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-polish.source mex.source mwcls.source polski.source tap.source "
inherit  texlive-module
DESCRIPTION="TeXLive Polish"

LICENSE=" GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2013
>=dev-texlive/texlive-basic-2013
!dev-texlive/texlive-documentation-polish
"
RDEPEND="${DEPEND} "
