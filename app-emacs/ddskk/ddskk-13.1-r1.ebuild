# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

inherit elisp

DESCRIPTION="One Japanese input methods on Emacs"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=app-emacs/apel-10.7"
RDEPEND="${DEPEND}
	|| ( app-i18n/skk-jisyo virtual/skkserv )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	find . -type f | xargs sed -i -e "s:/usr/local:${EPREFIX}/usr:g" || die
}

src_compile() {
	emake < /dev/null || die "emake failed"
	emake info < /dev/null || die "emake info failed"
	#cd nicola
	#make < /dev/null || die
	cd "${S}/tut-code"
	BYTECOMPFLAGS="${BYTECOMPFLAGS} -L .."
	elisp-compile *.el || die
}

src_install () {
	elisp-install ${PN} *.{el,elc} nicola/*.el tut-code/*.{el,elc} || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die

	insinto /usr/share/skk
	doins etc/*SKK.tut* etc/skk.xpm || die

	dodoc READMEs/* ChangeLog*
	doinfo doc/skk.info* || die

	#docinto nicola
	#dodoc nicola/ChangeLog* nicola/README*
	docinto tut-code
	dodoc tut-code/README.tut || die
}
