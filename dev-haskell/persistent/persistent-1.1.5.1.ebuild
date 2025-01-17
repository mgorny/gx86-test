# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Type-safe, multi-backend data serialization"
HOMEPAGE="http://www.yesodweb.com/book/persistent"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/aeson-0.5:=[profile?]
		dev-haskell/attoparsec:=[profile?]
		dev-haskell/base64-bytestring:=[profile?]
		>=dev-haskell/blaze-html-0.5:=[profile?]
		>=dev-haskell/blaze-markup-0.5.1:=[profile?]
		>=dev-haskell/conduit-0.5.5:=[profile?]
		>=dev-haskell/lifted-base-0.1:=[profile?]
		>=dev-haskell/monad-control-0.3:=[profile?]
		>=dev-haskell/monad-logger-0.2.3:=[profile?]
		>=dev-haskell/path-pieces-0.1:=[profile?]
		>=dev-haskell/pool-conduit-0.1.1:=[profile?]
		>=dev-haskell/resourcet-0.4:=[profile?]
		dev-haskell/silently:=[profile?]
		>=dev-haskell/text-0.8:=[profile?]
		>=dev-haskell/transformers-0.2.1:=[profile?]
		dev-haskell/transformers-base:=[profile?]
		dev-haskell/unordered-containers:=[profile?]
		dev-haskell/vector:=[profile?]
		>=dev-lang/ghc-6.12.1:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( >=dev-haskell/hspec-1.3
		)"
