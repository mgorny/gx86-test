# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour" # test-suite" breaks when installed version is broken
inherit haskell-cabal

DESCRIPTION="A cross-platform library for setting environment variables"
HOMEPAGE="http://hackage.haskell.org/package/setenv"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT=test # breaks when installed version is broken

RDEPEND=">=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		test? ( >=dev-haskell/hspec-1.3
			dev-haskell/quickcheck
		)
		>=dev-haskell/cabal-1.8"
