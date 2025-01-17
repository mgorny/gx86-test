# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="asyfig autoarea bardiag bloques bodegraph bondgraph braids bxeepic cachepic chemfig combinedgraphics circuitikz curve curve2e curves dcpic diagmac2 doc-pictex dottex  dratex drs duotenzor eepic  epspdfconversion esk fast-diagram fig4latex flowchart forest gincltex gnuplottex gradientframe grafcet here hf-tikz hobby hvfloat knitting knittingpattern lapdf lpic makeshape mathspic miniplot modiagram numericplots pb-diagram petri-nets  pgf-blur pgf-soroban pgf-umlsd pgfgantt pgfkeyx pgfmolbio pgfopts pgfplots piano picinpar pict2e pictex pictex2 pinlabel pmgraph prerex productbox pxpgfmark randbild randomwalk reotex rviewport sa-tikz schemabloc setdeck smartdiagram spath3 swimgraf texdraw tikz-3dplot tikz-bayesnet tikz-cd tikz-dependency tikz-inet tikz-qtree tikz-timing tikzinclude tikzmark tikzorbital tikzpagenodes tikzpfeile tikzposter tikzscale tikzsymbols tqft tkz-base tkz-berge tkz-doc tkz-euclide tkz-fct tkz-graph tkz-kiviat tkz-linknodes tkz-orm tkz-tab tsemlines tufte-latex venndiagram xpicture xypic collection-pictures
"
TEXLIVE_MODULE_DOC_CONTENTS="asyfig.doc autoarea.doc bardiag.doc bloques.doc bodegraph.doc bondgraph.doc braids.doc bxeepic.doc cachepic.doc chemfig.doc combinedgraphics.doc circuitikz.doc curve.doc curve2e.doc curves.doc dcpic.doc diagmac2.doc doc-pictex.doc dottex.doc dratex.doc drs.doc duotenzor.doc eepic.doc epspdfconversion.doc esk.doc fast-diagram.doc fig4latex.doc flowchart.doc forest.doc gincltex.doc gnuplottex.doc gradientframe.doc grafcet.doc here.doc hf-tikz.doc hobby.doc hvfloat.doc knitting.doc knittingpattern.doc lapdf.doc lpic.doc makeshape.doc mathspic.doc miniplot.doc modiagram.doc numericplots.doc pb-diagram.doc petri-nets.doc pgf-blur.doc pgf-soroban.doc pgf-umlsd.doc pgfgantt.doc pgfkeyx.doc pgfmolbio.doc pgfopts.doc pgfplots.doc piano.doc picinpar.doc pict2e.doc pictex.doc pinlabel.doc pmgraph.doc prerex.doc productbox.doc pxpgfmark.doc randbild.doc randomwalk.doc reotex.doc rviewport.doc sa-tikz.doc schemabloc.doc setdeck.doc smartdiagram.doc spath3.doc swimgraf.doc texdraw.doc tikz-3dplot.doc tikz-bayesnet.doc tikz-cd.doc tikz-dependency.doc tikz-inet.doc tikz-qtree.doc tikz-timing.doc tikzinclude.doc tikzmark.doc tikzorbital.doc tikzpagenodes.doc tikzpfeile.doc tikzposter.doc tikzscale.doc tikzsymbols.doc tqft.doc tkz-base.doc tkz-berge.doc tkz-doc.doc tkz-euclide.doc tkz-fct.doc tkz-graph.doc tkz-kiviat.doc tkz-linknodes.doc tkz-orm.doc tkz-tab.doc tufte-latex.doc venndiagram.doc xpicture.doc xypic.doc "
TEXLIVE_MODULE_SRC_CONTENTS="asyfig.source braids.source combinedgraphics.source curve.source curve2e.source curves.source dottex.source esk.source flowchart.source forest.source gincltex.source gnuplottex.source gradientframe.source hf-tikz.source hobby.source makeshape.source pgf-blur.source pgfgantt.source pgfmolbio.source pgfopts.source pgfplots.source pict2e.source productbox.source randbild.source randomwalk.source rviewport.source smartdiagram.source spath3.source tikz-timing.source tikzinclude.source tikzmark.source tikzpagenodes.source tikzpfeile.source tikzposter.source tikzscale.source tikzsymbols.source tqft.source tufte-latex.source venndiagram.source xpicture.source "
inherit  texlive-module
DESCRIPTION="TeXLive Graphics, pictures, diagrams"

LICENSE=" Apache-2.0 GPL-1 GPL-2 GPL-3 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!<dev-texlive/texlive-latexextra-2009
!<dev-texlive/texlive-texinfo-2009
dev-tex/pgf
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/cachepic/cachepic.tlu texmf-dist/scripts/fig4latex/fig4latex texmf-dist/scripts/mathspic/mathspic.pl"
