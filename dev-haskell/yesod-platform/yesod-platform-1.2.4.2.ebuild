# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Meta package for Yesod"
HOMEPAGE="http://www.yesodweb.com/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/aeson-0.6.2.0:=[profile?]
	>=dev-haskell/ansi-terminal-0.6:=[profile?]
	>=dev-haskell/asn1-data-0.7.1:=[profile?]
	>=dev-haskell/asn1-types-0.2.0:=[profile?]
	>=dev-haskell/attoparsec-0.10.4.0:=[profile?]
	>=dev-haskell/attoparsec-conduit-1.0.1.2:=[profile?]
	>=dev-haskell/authenticate-1.3.2.6:=[profile?]
	>=dev-haskell/base-unicode-symbols-0.2.2.4:=[profile?]
	>=dev-haskell/base64-bytestring-1.0.0.1:=[profile?]
	>=dev-haskell/blaze-builder-0.3.1.1:=[profile?]
	>=dev-haskell/blaze-builder-conduit-1.0.0:=[profile?]
	>=dev-haskell/blaze-html-0.6.1.1:=[profile?]
	>=dev-haskell/blaze-markup-0.5.1.5:=[profile?]
	>=dev-haskell/byteable-0.1.1:=[profile?]
	>=dev-haskell/byteorder-1.0.4:=[profile?]
	>=dev-haskell/case-insensitive-1.1:=[profile?]
	>=dev-haskell/cereal-0.3.5.2:=[profile?]
	>=dev-haskell/certificate-1.3.8:=[profile?]
	>=dev-haskell/cipher-aes-0.2.5:=[profile?]
	>=dev-haskell/cipher-rc4-0.1.2:=[profile?]
	>=dev-haskell/clientsession-0.9.0.3:=[profile?]
	>=dev-haskell/conduit-1.0.7.4:=[profile?]
	>=dev-haskell/cookie-0.4.0.1:=[profile?]
	>=dev-haskell/cprng-aes-0.5.2:=[profile?]
	>=dev-haskell/crypto-api-0.12.2.2:=[profile?]
	>=dev-haskell/crypto-cipher-types-0.0.4:=[profile?]
	>=dev-haskell/crypto-conduit-0.5.2:=[profile?]
	>=dev-haskell/crypto-numbers-0.2.1:=[profile?]
	>=dev-haskell/crypto-pubkey-0.2.1:=[profile?]
	>=dev-haskell/crypto-pubkey-types-0.4.0:=[profile?]
	>=dev-haskell/crypto-random-0.0.7:=[profile?]
	>=dev-haskell/cryptohash-0.10.0:=[profile?]
	>=dev-haskell/cryptohash-cryptoapi-0.1.0:=[profile?]
	>=dev-haskell/css-text-0.1.1:=[profile?]
	>=dev-haskell/data-default-0.5.3:=[profile?]
	>=dev-haskell/data-default-class-0.0.1:=[profile?]
	>=dev-haskell/data-default-instances-base-0.0.1:=[profile?]
	>=dev-haskell/data-default-instances-containers-0.0.1:=[profile?]
	>=dev-haskell/data-default-instances-dlist-0.0.1:=[profile?]
	>=dev-haskell/data-default-instances-old-locale-0.0.1:=[profile?]
	>=dev-haskell/date-cache-0.3.0:=[profile?]
	>=dev-haskell/dlist-0.5:=[profile?]
	>=dev-haskell/email-validate-1.0.0:=[profile?]
	>=dev-haskell/entropy-0.2.2.2:=[profile?]
	>=dev-haskell/failure-0.2.0.1:=[profile?]
	>=dev-haskell/fast-logger-0.3.3:=[profile?]
	>=dev-haskell/file-embed-0.0.4.9:=[profile?]
	>=dev-haskell/filesystem-conduit-1.0.0.1:=[profile?]
	>=dev-haskell/hamlet-1.1.7.2:=[profile?]
	>=dev-haskell/hjsmin-0.1.4.1:=[profile?]
	>=dev-haskell/hspec-1.7.2:=[profile?]
	>=dev-haskell/hspec-expectations-0.3.3:=[profile?]
	>=dev-haskell/html-conduit-1.1.0:=[profile?]
	>=dev-haskell/http-attoparsec-0.1.0:=[profile?]
	>=dev-haskell/http-conduit-1.9.4.5:=[profile?]
	>=dev-haskell/http-date-0.0.4:=[profile?]
	>=dev-haskell/http-types-0.8.1:=[profile?]
	>=dev-haskell/language-javascript-0.5.7:=[profile?]
	>=dev-haskell/lifted-base-0.2.1.0:=[profile?]
	>=dev-haskell/mime-mail-0.4.2.1:=[profile?]
	>=dev-haskell/mime-types-0.1.0.3:=[profile?]
	>=dev-haskell/mmorph-1.0.0:=[profile?]
	>=dev-haskell/monad-control-0.3.2.1:=[profile?]
	>=dev-haskell/monad-logger-0.3.1.1:=[profile?]
	>=dev-haskell/network-conduit-1.0.0:=[profile?]
	>=dev-haskell/path-pieces-0.1.2:=[profile?]
	>=dev-haskell/pem-0.1.2:=[profile?]
	>=dev-haskell/persistent-1.2.3.0:=[profile?]
	>=dev-haskell/persistent-template-1.2.0.2:=[profile?]
	>=dev-haskell/pool-conduit-0.1.2:=[profile?]
	>=dev-haskell/primitive-0.5.0.1:=[profile?]
	>=dev-haskell/publicsuffixlist-0.1:=[profile?]
	>=dev-haskell/puremd5-2.1.2.1:=[profile?]
	>=dev-haskell/pwstore-fast-2.3:=[profile?]
	>=dev-haskell/quickcheck-io-0.1.0:=[profile?]
	>=dev-haskell/resource-pool-0.2.1.1:=[profile?]
	>=dev-haskell/resourcet-0.4.8:=[profile?]
	>=dev-haskell/safe-0.3.3:=[profile?]
	>=dev-haskell/securemem-0.1.3:=[profile?]
	>=dev-haskell/semigroups-0.9.2:=[profile?]
	>=dev-haskell/setenv-0.1.0:=[profile?]
	>=dev-haskell/sha-1.6.1:=[profile?]
	>=dev-haskell/shakespeare-1.2.0:=[profile?]
	>=dev-haskell/shakespeare-css-1.0.6.3:=[profile?]
	>=dev-haskell/shakespeare-i18n-1.0.0.4:=[profile?]
	>=dev-haskell/shakespeare-js-1.2.0:=[profile?]
	>=dev-haskell/shakespeare-text-1.0.0.7:=[profile?]
	>=dev-haskell/silently-1.2.4.1:=[profile?]
	>=dev-haskell/simple-sendfile-0.2.12:=[profile?]
	>=dev-haskell/skein-1.0.6:=[profile?]
	>=dev-haskell/socks-0.5.1:=[profile?]
	>=dev-haskell/stringsearch-0.3.6.4:=[profile?]
	>=dev-haskell/system-fileio-0.3.11:=[profile?]
	>=dev-haskell/system-filepath-0.4.7:=[profile?]
	>=dev-haskell/tagged-0.7:=[profile?]
	>=dev-haskell/tagsoup-0.13:=[profile?]
	>=dev-haskell/tagstream-conduit-0.5.4:=[profile?]
	>=dev-haskell/tls-1.1.5:=[profile?]
	>=dev-haskell/tls-extra-0.6.5:=[profile?]
	>=dev-haskell/transformers-base-0.4.1:=[profile?]
	>=dev-haskell/unix-compat-0.4.1.1:=[profile?]
	>=dev-haskell/unordered-containers-0.2.3.2:=[profile?]
	>=dev-haskell/utf8-light-0.4.0.1:=[profile?]
	>=dev-haskell/utf8-string-0.3.7:=[profile?]
	>=dev-haskell/vector-0.10.0.1:=[profile?]
	>=dev-haskell/void-0.6.1:=[profile?]
	>=dev-haskell/wai-1.4.0.2:=[profile?]
	>=dev-haskell/wai-app-static-1.3.1.4:=[profile?]
	>=dev-haskell/wai-extra-1.3.4.4:=[profile?]
	>=dev-haskell/wai-logger-0.3.1:=[profile?]
	>=dev-haskell/wai-test-1.3.1.1:=[profile?]
	>=dev-haskell/warp-1.3.9.2:=[profile?]
	>=dev-haskell/word8-0.0.3:=[profile?]
	>=dev-haskell/xml-conduit-1.1.0.7:=[profile?]
	>=dev-haskell/xml-types-0.3.4:=[profile?]
	>=dev-haskell/xss-sanitize-0.3.4:=[profile?]
	>=dev-haskell/yaml-0.8.4.1:=[profile?]
	>=dev-haskell/yesod-1.2.2.1:=[profile?]
	>=dev-haskell/yesod-auth-1.2.2.1:=[profile?]
	>=dev-haskell/yesod-core-1.2.4.2:=[profile?]
	>=dev-haskell/yesod-form-1.3.2.1:=[profile?]
	>=dev-haskell/yesod-persistent-1.2.1:=[profile?]
	>=dev-haskell/yesod-routes-1.2.0.1:=[profile?]
	>=dev-haskell/yesod-static-1.2.0.1:=[profile?]
	>=dev-haskell/yesod-test-1.2.1:=[profile?]
	>=dev-haskell/zlib-bindings-0.1.1.3:=[profile?]
	>=dev-haskell/zlib-conduit-1.0.0:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
"

src_prepare() {
	cabal_chdeps \
		' == ' ' >= '
}
