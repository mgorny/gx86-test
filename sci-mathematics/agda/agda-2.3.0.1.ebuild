# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

CABAL_FEATURES="lib profile"
inherit haskell-cabal eutils elisp-common

MY_PN="Agda"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A dependently typed functional programming language and proof assistant"
HOMEPAGE="http://wiki.portal.chalmers.se/agda/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="epic +stdlib"

RDEPEND=">=dev-haskell/binary-0.4.4[profile?]
		<dev-haskell/binary-0.6[profile?]
		epic? ( dev-lang/epic[profile?] )
		=dev-haskell/hashable-1.1*[profile?]
		=dev-haskell/hashtables-1.0*[profile?]
		>=dev-haskell/haskeline-0.6.3.2[profile?]
		<dev-haskell/haskeline-0.7[profile?]
		>=dev-haskell/haskell-src-exts-1.9.6[profile?]
		<dev-haskell/haskell-src-exts-1.14[profile?]
		>=dev-haskell/mtl-2.0[profile?]
		<dev-haskell/mtl-2.2[profile?]
		=dev-haskell/quickcheck-2.4*[profile?]
		>=dev-haskell/syb-0.1[profile?]
		<dev-haskell/syb-0.4[profile?]
		=dev-haskell/xhtml-3000.2*[profile?]
		>=dev-haskell/zlib-0.4.0.1[profile?]
		<dev-haskell/zlib-0.6[profile?]
		>=dev-lang/ghc-6.10.4
		virtual/emacs
		app-emacs/haskell-mode"
PDEPEND="stdlib? ( sci-mathematics/agda-stdlib )"
DEPEND="${RDEPEND}
		dev-haskell/alex
		>=dev-haskell/cabal-1.8
		dev-haskell/happy"

SITEFILE="50${PN}2-gentoo.el"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-emacs.patch
	epatch "${FILESDIR}"/${PN}-2.3.0.1-haskell-src-exts-1.13.patch
	epatch "${FILESDIR}"/${PN}-2.3.0.1-mtl-2.1.patch
	cabal-mksetup
}

src_configure() {
	cabal_src_configure $(cabal_flag epic)
}

src_install() {
	haskell-cabal_src_install
	elisp-install ${PN} src/data/emacs-mode/*.el \
		|| die "Failed to install emacs mode"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
		|| die "Failed to install elisp site file"
}

pkg_postinst() {
	ghc-package_pkg_postinst
	elisp-site-regen
}

pkg_postrm() {
	ghc-package_pkg_prerm
	elisp-site-regen
}
