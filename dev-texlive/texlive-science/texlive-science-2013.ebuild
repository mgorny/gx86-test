# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="SIstyle SIunits alg algorithm2e algorithmicx algorithms biocon bohr bpchem bytefield chemarrow chemcompounds chemcono chemexec chemmacros chemnum chemstyle clrscode complexity computational-complexity digiconfigs drawstack dyntree eltex endiagram engtlc fouridx functan galois gastex gene-logic gu hep hepnames hepparticles hepthesis hepunits karnaugh mhchem miller mychemistry nuc objectz physics physymb pseudocode sasnrdisplay sciposter sfg siunitx steinmetz struktex substances t-angles textopo ulqda unitsdef youngtab collection-science
"
TEXLIVE_MODULE_DOC_CONTENTS="SIstyle.doc SIunits.doc alg.doc algorithm2e.doc algorithmicx.doc algorithms.doc biocon.doc bohr.doc bpchem.doc bytefield.doc chemarrow.doc chemcompounds.doc chemcono.doc chemexec.doc chemmacros.doc chemnum.doc chemstyle.doc clrscode.doc complexity.doc computational-complexity.doc digiconfigs.doc drawstack.doc dyntree.doc eltex.doc endiagram.doc engtlc.doc fouridx.doc functan.doc galois.doc gastex.doc gene-logic.doc gu.doc hep.doc hepnames.doc hepparticles.doc hepthesis.doc hepunits.doc karnaugh.doc mhchem.doc miller.doc mychemistry.doc nuc.doc objectz.doc physics.doc physymb.doc pseudocode.doc sasnrdisplay.doc sciposter.doc sfg.doc siunitx.doc steinmetz.doc struktex.doc substances.doc t-angles.doc textopo.doc ulqda.doc unitsdef.doc youngtab.doc "
TEXLIVE_MODULE_SRC_CONTENTS="SIstyle.source SIunits.source alg.source algorithms.source bpchem.source bytefield.source chemarrow.source chemcompounds.source chemstyle.source computational-complexity.source dyntree.source fouridx.source functan.source galois.source miller.source objectz.source physymb.source siunitx.source steinmetz.source struktex.source textopo.source ulqda.source unitsdef.source youngtab.source "
inherit  texlive-module
DESCRIPTION="TeXLive Natural and computer sciences"

LICENSE=" GPL-1 GPL-2 LGPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2013
!dev-tex/SIunits
"
RDEPEND="${DEPEND} dev-texlive/texlive-pstricks
"
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/ulqda/ulqda.pl"
