# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Simple monadic parser for ASN1 stream types"
HOMEPAGE="http://github.com/vincenthz/hs-asn1"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/asn1-encoding-0.8:=[profile?]
	>=dev-haskell/asn1-types-0.2:=[profile?] <dev-haskell/asn1-types-0.3:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/text-0.11:=[profile?]
	>=dev-lang/ghc-6.12.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
"
