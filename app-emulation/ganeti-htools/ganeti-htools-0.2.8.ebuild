# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils multilib

DESCRIPTION="Cluster tools for fixing common allocation problems on Ganeti 2.0
clusters"
HOMEPAGE="http://code.google.com/p/ganeti/"
SRC_URI="http://ganeti.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

DEPEND="dev-lang/ghc
	dev-haskell/json
	dev-haskell/curl
	dev-haskell/network"
RDEPEND="${DEPEND}
	!>=app-emulation/ganeti-2.4"
DEPEND+=" test? ( dev-haskell/quickcheck:1 )"

src_prepare() {
	# htools does not currently compile cleanly with ghc-6.12+, so remove this
	# for now
	sed -i -e "s:-Werror ::" Makefile
	epatch "${FILESDIR}"/${P}-use-QC-1.patch #316629
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	dosbin hspace hscan hbal
	exeinto /usr/$(get_libdir)/ganeti/iallocators
	doexe hail
	doman *.1
	dodoc README NEWS AUTHORS
	use doc && dohtml -r apidoc/*
}
