# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit flag-o-matic

DESCRIPTION="groovy little assembler"
HOMEPAGE="http://nasm.sourceforge.net/"
SRC_URI="http://www.nasm.us/pub/nasm/releasebuilds/${PV/_}/${P/_}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

DEPEND="dev-lang/perl
	doc? ( app-text/ghostscript-gpl sys-apps/texinfo )"
RDEPEND=""

S=${WORKDIR}/${P/_}

src_configure() {
	strip-flags
	econf
}

src_compile() {
	emake nasmlib.o
	emake all
	use doc && emake doc
}

src_install() {
	emake INSTALLROOT="${D}" install install_rdf
	dodoc AUTHORS CHANGES ChangeLog README TODO
	if use doc ; then
		doinfo doc/info/*
		dohtml doc/html/*
		dodoc doc/nasmdoc.*
	fi
}
