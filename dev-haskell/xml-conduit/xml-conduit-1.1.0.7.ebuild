# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Pure-Haskell utilities for dealing with XML with the conduit package"
HOMEPAGE="http://github.com/snoyberg/xml"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/attoparsec-0.10:=[profile?]
	>=dev-haskell/attoparsec-conduit-1.0:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	>=dev-haskell/blaze-builder-0.2:=[profile?] <dev-haskell/blaze-builder-0.4:=[profile?]
	>=dev-haskell/blaze-builder-conduit-1.0:=[profile?]
	>=dev-haskell/blaze-html-0.5:=[profile?]
	>=dev-haskell/blaze-markup-0.5:=[profile?]
	>=dev-haskell/conduit-1.0:=[profile?] <dev-haskell/conduit-1.1:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/deepseq-1.1.0.0:=[profile?]
	>=dev-haskell/failure-0.1:=[profile?] <dev-haskell/failure-0.3:=[profile?]
	>=dev-haskell/monad-control-0.3:=[profile?] <dev-haskell/monad-control-0.4:=[profile?]
	>=dev-haskell/resourcet-0.3:=[profile?] <dev-haskell/resourcet-0.5:=[profile?]
	>=dev-haskell/system-filepath-0.4:=[profile?] <dev-haskell/system-filepath-0.5:=[profile?]
	>=dev-haskell/text-0.7:=[profile?] <dev-haskell/text-0.12:=[profile?]
	>=dev-haskell/transformers-0.2:=[profile?] <dev-haskell/transformers-0.4:=[profile?]
	>=dev-haskell/xml-types-0.3.4:=[profile?] <dev-haskell/xml-types-0.4:=[profile?]
"
DEPEND="${RDEPEND}
	test? ( dev-haskell/conduit
		>=dev-haskell/hspec-1.3
		dev-haskell/hunit
		dev-haskell/text
		dev-haskell/transformers
		>=dev-haskell/xml-types-0.3.1 )
	>=dev-haskell/cabal-1.8
"
