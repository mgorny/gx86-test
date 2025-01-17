# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

DESCRIPTION="vilearn is an interactive vi tutorial comprised of 5 tutorials for the vi-impaired"
HOMEPAGE="http://vilearn.org/"
SRC_URI="http://vilearn.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="app-editors/vim"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i "s:/usr/local:${EPREFIX}/usr:" Makefile
}

src_install() {
	dobin vilearn
	doman vilearn.1
	dodoc README outline

	insinto /usr/lib/vilearn
	doins [0-9]*
}
