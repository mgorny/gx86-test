# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Encode unicode strings to ascii forms according to RFC 3492"
HOMEPAGE="https://github.com/litherum/punycode"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT=test # runs slow, finds error

RDEPEND="dev-haskell/cereal:=[profile?]
		dev-haskell/mtl:=[profile?]
		dev-haskell/text:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( dev-haskell/encoding
			dev-haskell/hunit
			dev-haskell/quickcheck
		)"
