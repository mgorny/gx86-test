# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Crypto-api interfaces for cryptohash"
HOMEPAGE="http://github.com/vincenthz/hs-cryptohash-cryptoapi"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/cereal-0.2:=[profile?]
	>=dev-haskell/crypto-api-0.11:=[profile?]
	>=dev-haskell/cryptohash-0.8.0:=[profile?]
	>=dev-haskell/tagged-0.1:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
"
