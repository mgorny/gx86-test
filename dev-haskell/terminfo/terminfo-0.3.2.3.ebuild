# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# ebuild generated by hackport 0.2.14

EAPI="3"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit autotools eutils haskell-cabal

DESCRIPTION="Haskell bindings to the terminfo library"
HOMEPAGE="http://code.haskell.org/terminfo"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.10.4
		sys-libs/ncurses"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.4"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.2.5-tinfo.patch

	eautoreconf
}
