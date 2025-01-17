# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Form handling support for Yesod Web Framework"
HOMEPAGE="http://www.yesodweb.com/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/aeson:=[profile?]
	>=dev-haskell/attoparsec-0.10:=[profile?]
	>=dev-haskell/blaze-builder-0.2.1.4:=[profile?]
	>=dev-haskell/blaze-html-0.5:=[profile?]
	>=dev-haskell/blaze-markup-0.5.1:=[profile?]
	>=dev-haskell/crypto-api-0.8:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/email-validate-1.0:=[profile?]
	>=dev-haskell/hamlet-1.1:=[profile?] <dev-haskell/hamlet-1.2:=[profile?]
	>=dev-haskell/network-2.2:=[profile?]
	>=dev-haskell/persistent-1.2:=[profile?] <dev-haskell/persistent-1.3:=[profile?]
	dev-haskell/resourcet:=[profile?]
	>=dev-haskell/shakespeare-css-1.0:=[profile?] <dev-haskell/shakespeare-css-1.1:=[profile?]
	>=dev-haskell/shakespeare-js-1.0.2:=[profile?] <dev-haskell/shakespeare-js-1.3:=[profile?]
	>=dev-haskell/text-0.9:=[profile?]
	>=dev-haskell/transformers-0.2.2:=[profile?]
	>=dev-haskell/wai-1.3:=[profile?]
	>=dev-haskell/xss-sanitize-0.3.0.1:=[profile?]
	>=dev-haskell/yesod-core-1.2:=[profile?] <dev-haskell/yesod-core-1.3:=[profile?]
	>=dev-haskell/yesod-persistent-1.2:=[profile?] <dev-haskell/yesod-persistent-1.3:=[profile?]
	>=dev-lang/ghc-6.12.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
	test? ( dev-haskell/hspec )
"
