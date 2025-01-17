# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="HTTP client package with conduit interface and HTTPS support"
HOMEPAGE="http://www.yesodweb.com/book/http-conduit"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/conduit-0.5.5:=[profile?] <dev-haskell/conduit-1.1:=[profile?]
	>=dev-haskell/http-client-0.2:=[profile?]
	dev-haskell/http-client-conduit:=[profile?]
	dev-haskell/http-client-tls:=[profile?]
	>=dev-haskell/http-types-0.7:=[profile?]
	>=dev-haskell/lifted-base-0.1:=[profile?]
	>=dev-haskell/resourcet-0.3:=[profile?] <dev-haskell/resourcet-0.5:=[profile?]
	>=dev-haskell/transformers-0.2:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( dev-haskell/asn1-data
		dev-haskell/base64-bytestring
		dev-haskell/blaze-builder
		dev-haskell/blaze-builder-conduit
		dev-haskell/case-insensitive
		dev-haskell/certificate
		dev-haskell/connection
		dev-haskell/cookie
		dev-haskell/cprng-aes
		dev-haskell/data-default
		dev-haskell/deepseq
		dev-haskell/failure
		>=dev-haskell/hspec-1.3
		dev-haskell/http-client-multipart
		dev-haskell/hunit
		dev-haskell/mime-types
		dev-haskell/monad-control
		dev-haskell/mtl
		dev-haskell/network
		>=dev-haskell/network-conduit-0.6
		dev-haskell/publicsuffixlist
		dev-haskell/random
		dev-haskell/regex-compat
		dev-haskell/socks
		dev-haskell/text
		dev-haskell/tls
		dev-haskell/tls-extra
		dev-haskell/transformers-base
		dev-haskell/utf8-string
		dev-haskell/void
		>=dev-haskell/wai-2.0 <dev-haskell/wai-2.1
		>=dev-haskell/warp-2.0 <dev-haskell/warp-2.1
		dev-haskell/warp-tls
		dev-haskell/zlib-conduit )
"
