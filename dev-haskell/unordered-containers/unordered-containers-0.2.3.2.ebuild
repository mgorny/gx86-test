# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Efficient hashing-based container types"
HOMEPAGE="https://github.com/tibbe/unordered-containers"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-haskell/deepseq-1.1:=[profile?]
	>=dev-haskell/hashable-1.0.1.1:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( dev-haskell/chasingbottoms
		dev-haskell/hunit
		>=dev-haskell/quickcheck-2.4.0.1
		>=dev-haskell/test-framework-0.3.3
		dev-haskell/test-framework-hunit
		>=dev-haskell/test-framework-quickcheck2-0.2.9 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag debug debug)
}
