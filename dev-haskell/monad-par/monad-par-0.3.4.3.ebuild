# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A library for parallel programming based on a monad"
HOMEPAGE="https://github.com/simonmar/monad-par"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/abstract-deque-0.1.4:=[profile?]
		dev-haskell/abstract-par:=[profile?]
		>=dev-haskell/deepseq-1.1:=[profile?]
		>=dev-haskell/monad-par-extras-0.3:=[profile?]
		>=dev-haskell/mtl-2.0.1.0:=[profile?]
		>=dev-haskell/mwc-random-0.11:=[profile?]
		>=dev-haskell/parallel-3.1:=[profile?]
		>=dev-lang/ghc-6.12.1:=
		"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( dev-haskell/hunit
			dev-haskell/quickcheck
			dev-haskell/test-framework
			dev-haskell/test-framework-hunit
			>=dev-haskell/test-framework-quickcheck2-0.3
			dev-haskell/test-framework-th
		)"
