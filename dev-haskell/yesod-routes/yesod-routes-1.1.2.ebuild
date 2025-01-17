# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Efficient routing for Yesod"
HOMEPAGE="http://www.yesodweb.com/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=dev-haskell/path-pieces-0.1*:=[profile?]
		>=dev-haskell/text-0.5:=[profile?]
		<dev-haskell/text-0.12:=[profile?]
		>=dev-haskell/vector-0.8:=[profile?]
		<dev-haskell/vector-0.11:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		test? ( >=dev-haskell/hspec-1.3
			=dev-haskell/hunit-1.2*
		)
		>=dev-haskell/cabal-1.8"
