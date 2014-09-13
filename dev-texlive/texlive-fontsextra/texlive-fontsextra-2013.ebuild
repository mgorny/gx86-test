# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="Asana-Math adforn adfsymbols aecc allrunes antiqua antt archaic arev ascii-font aspectratio astro augie auncial-new aurical b1encoding barcodes baskervald bbding bbm bbm-macros bbold bbold-type1 belleek bera berenisadf bguq blacklettert1 boisik bookhands boondox braille brushscr cabin calligra calligra-type1 cantarell carolmin-ps ccicons cfr-lm cherokee cm-lgc cm-unicode cmbright cmll cmpica cmtiup comfortaa concmath-fonts cookingsymbols countriesofeurope courier-scaled cryst cyklop dancers dejavu dice dictsym dingbat doublestroke dozenal droid duerer duerer-latex dutchcal ean ebgaramond ecc eco eiad eiad-ltx electrum elvish epigrafica epsdice esstix esvect eulervm euxm fdsymbol feyn fge foekfont fonetika fontawesome fourier fouriernc frcursive genealogy gentium gfsartemisia gfsbodoni gfscomplutum gfsdidot gfsneohellenic gfssolomos gillcm gnu-freefont gothic greenpoint grotesq hacm hands hfbright hfoldsty ifsym inconsolata initials ipaex-type1 iwona jablantile jamtimes junicode kixfont knuthotherfonts kpfonts kurier lato lfb libertine librebaskerville libris linearA lxfonts ly1 mathabx mathabx-type1 mathdesign mdputu mdsymbol mnsymbol newpx newtx nkarta ocherokee ocr-b ocr-b-outline ogham oinuit oldlatin oldstandard opensans orkhun pacioli paratype phaistos phonetic pigpen poltawski prodint punk punk-latex punknova pxtxalfa quattrocento raleway recycle romande rsfso sansmathaccent sansmathfonts sauter sauterfonts schulschriften semaphor skull sourcecodepro sourcesanspro starfont staves stix superiors tapir tengwarscript tfrupee tpslifonts trajan txfontsb umtypewriter universa urwchancal venturisadf wsuipa xits yfonts collection-fontsextra
"
TEXLIVE_MODULE_DOC_CONTENTS="Asana-Math.doc adforn.doc adfsymbols.doc aecc.doc allrunes.doc antiqua.doc antt.doc archaic.doc arev.doc ascii-font.doc aspectratio.doc astro.doc augie.doc auncial-new.doc aurical.doc b1encoding.doc barcodes.doc baskervald.doc bbding.doc bbm.doc bbm-macros.doc bbold.doc bbold-type1.doc belleek.doc bera.doc berenisadf.doc bguq.doc blacklettert1.doc boisik.doc bookhands.doc boondox.doc braille.doc brushscr.doc cabin.doc calligra.doc calligra-type1.doc cantarell.doc carolmin-ps.doc ccicons.doc cfr-lm.doc cherokee.doc cm-lgc.doc cm-unicode.doc cmbright.doc cmll.doc cmpica.doc cmtiup.doc comfortaa.doc concmath-fonts.doc cookingsymbols.doc countriesofeurope.doc courier-scaled.doc cryst.doc cyklop.doc dejavu.doc dice.doc dictsym.doc dingbat.doc doublestroke.doc dozenal.doc droid.doc duerer.doc duerer-latex.doc dutchcal.doc ean.doc ebgaramond.doc ecc.doc eco.doc eiad.doc eiad-ltx.doc electrum.doc elvish.doc epigrafica.doc epsdice.doc esstix.doc esvect.doc eulervm.doc fdsymbol.doc feyn.doc fge.doc foekfont.doc fonetika.doc fontawesome.doc fourier.doc fouriernc.doc frcursive.doc genealogy.doc gentium.doc gfsartemisia.doc gfsbodoni.doc gfscomplutum.doc gfsdidot.doc gfsneohellenic.doc gfssolomos.doc gillcm.doc gnu-freefont.doc gothic.doc greenpoint.doc grotesq.doc hacm.doc hfbright.doc hfoldsty.doc ifsym.doc inconsolata.doc initials.doc ipaex-type1.doc iwona.doc jablantile.doc jamtimes.doc junicode.doc kixfont.doc kpfonts.doc kurier.doc lato.doc lfb.doc libertine.doc librebaskerville.doc libris.doc linearA.doc lxfonts.doc ly1.doc mathabx.doc mathabx-type1.doc mathdesign.doc mdputu.doc mdsymbol.doc mnsymbol.doc newpx.doc newtx.doc nkarta.doc ocherokee.doc ocr-b.doc ocr-b-outline.doc ogham.doc oinuit.doc oldlatin.doc oldstandard.doc opensans.doc orkhun.doc pacioli.doc paratype.doc phaistos.doc phonetic.doc pigpen.doc poltawski.doc prodint.doc punk.doc punk-latex.doc punknova.doc pxtxalfa.doc quattrocento.doc raleway.doc recycle.doc romande.doc rsfso.doc sansmathaccent.doc sansmathfonts.doc sauterfonts.doc schulschriften.doc semaphor.doc sourcecodepro.doc sourcesanspro.doc starfont.doc staves.doc stix.doc superiors.doc tapir.doc tengwarscript.doc tfrupee.doc tpslifonts.doc trajan.doc txfontsb.doc universa.doc urwchancal.doc venturisadf.doc wsuipa.doc xits.doc yfonts.doc "
TEXLIVE_MODULE_SRC_CONTENTS="allrunes.source archaic.source arev.source ascii-font.source auncial-new.source b1encoding.source barcodes.source baskervald.source bbding.source bbm-macros.source bbold.source belleek.source berenisadf.source bguq.source blacklettert1.source bookhands.source cantarell.source ccicons.source cfr-lm.source cmbright.source cmll.source comfortaa.source cookingsymbols.source dingbat.source dozenal.source droid.source eco.source eiad-ltx.source electrum.source epsdice.source esvect.source eulervm.source fdsymbol.source feyn.source fge.source fourier.source gentium.source gnu-freefont.source hfoldsty.source inconsolata.source lato.source libris.source linearA.source mdsymbol.source mnsymbol.source nkarta.source ocr-b-outline.source oinuit.source oldstandard.source opensans.source pacioli.source phaistos.source romande.source sauterfonts.source skull.source staves.source tengwarscript.source tfrupee.source tpslifonts.source trajan.source txfontsb.source universa.source venturisadf.source xits.source yfonts.source "
inherit  texlive-module
DESCRIPTION="TeXLive Additional fonts"

LICENSE=" BSD GPL-1 GPL-2 GPL-3 LPPL-1.2 LPPL-1.3 OFL public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!=dev-texlive/texlive-langpolish-2007*
"
RDEPEND="${DEPEND} "
