# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.4.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Conversion between markup formats"
HOMEPAGE="http://johnmacfarlane.net/pandoc"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="embed_data_files +http-conduit"

RESTRICT=test # missing files

RDEPEND=">=dev-haskell/aeson-0.7:=[profile?] <dev-haskell/aeson-0.8:=[profile?]
	>=dev-haskell/attoparsec-0.10:=[profile?] <dev-haskell/attoparsec-0.13:=[profile?]
	>=dev-haskell/base64-bytestring-0.1:=[profile?] <dev-haskell/base64-bytestring-1.1:=[profile?]
	>=dev-haskell/binary-0.5:=[profile?] <dev-haskell/binary-0.8:=[profile?]
	>=dev-haskell/blaze-html-0.5:=[profile?] <dev-haskell/blaze-html-0.8:=[profile?]
	>=dev-haskell/blaze-markup-0.5.1:=[profile?] <dev-haskell/blaze-markup-0.7:=[profile?]
	>=dev-haskell/data-default-0.4:=[profile?] <dev-haskell/data-default-0.6:=[profile?]
	>=dev-haskell/extensible-exceptions-0.1:=[profile?] <dev-haskell/extensible-exceptions-0.2:=[profile?]
	>=dev-haskell/highlighting-kate-0.5.8:=[profile?] <dev-haskell/highlighting-kate-0.6:=[profile?]
	>=dev-haskell/hslua-0.3:=[profile?] <dev-haskell/hslua-0.4:=[profile?]
	>=dev-haskell/http-4000.0.5:=[profile?] <dev-haskell/http-4000.3:=[profile?]
	>=dev-haskell/mtl-1.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/network-2:=[profile?] <dev-haskell/network-2.6:=[profile?]
	>=dev-haskell/pandoc-types-1.12.3.3:=[profile?] <dev-haskell/pandoc-types-1.13:=[profile?]
	>=dev-haskell/parsec-3.1:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	>=dev-haskell/random-1:=[profile?] <dev-haskell/random-1.1:=[profile?]
	>=dev-haskell/scientific-0.2:=[profile?] <dev-haskell/scientific-0.4:=[profile?]
	>=dev-haskell/syb-0.1:=[profile?] <dev-haskell/syb-0.5:=[profile?]
	>=dev-haskell/tagsoup-0.13.1:=[profile?] <dev-haskell/tagsoup-0.14:=[profile?]
	>=dev-haskell/temporary-1.1:=[profile?] <dev-haskell/temporary-1.3:=[profile?]
	>=dev-haskell/texmath-0.6.6.1:=[profile?] <dev-haskell/texmath-0.7:=[profile?]
	>=dev-haskell/text-0.11:=[profile?] <dev-haskell/text-1.2:=[profile?]
	>=dev-haskell/unordered-containers-0.2:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-haskell/vector-0.10:=[profile?] <dev-haskell/vector-0.11:=[profile?]
	>=dev-haskell/xml-1.3.12:=[profile?] <dev-haskell/xml-1.4:=[profile?]
	>=dev-haskell/yaml-0.8.8.2:=[profile?] <dev-haskell/yaml-0.9:=[profile?]
	>=dev-haskell/zip-archive-0.1.3.3:=[profile?] <dev-haskell/zip-archive-0.3:=[profile?]
	>=dev-haskell/zlib-0.5:=[profile?] <dev-haskell/zlib-0.6:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	http-conduit? ( >=dev-haskell/http-conduit-1.9:=[profile?] <dev-haskell/http-conduit-2.2:=[profile?]
			>=dev-haskell/http-types-0.8:=[profile?] <dev-haskell/http-types-0.9:=[profile?] )
"
DEPEND="${RDEPEND}
	dev-haskell/alex
	>=dev-haskell/cabal-1.10
	dev-haskell/happy
	test? ( >=dev-haskell/ansi-terminal-0.5 <dev-haskell/ansi-terminal-0.7
		>=dev-haskell/diff-0.2 <dev-haskell/diff-0.4
		>=dev-haskell/highlighting-kate-0.5.8 <dev-haskell/highlighting-kate-0.6
		>=dev-haskell/hunit-1.2 <dev-haskell/hunit-1.3
		>=dev-haskell/pandoc-types-1.12.3.3 <dev-haskell/pandoc-types-1.13
		>=dev-haskell/quickcheck-2.4 <dev-haskell/quickcheck-2.8
		>=dev-haskell/syb-0.1 <dev-haskell/syb-0.5
		>=dev-haskell/test-framework-0.3 <dev-haskell/test-framework-0.9
		>=dev-haskell/test-framework-hunit-0.2 <dev-haskell/test-framework-hunit-0.4
		>=dev-haskell/test-framework-quickcheck2-0.2.9 <dev-haskell/test-framework-quickcheck2-0.4
		>=dev-haskell/text-0.11 <dev-haskell/text-1.2 )
"

src_prepare() {
	cabal_chdeps \
		'scientific >= 0.2 && < 0.3' 'scientific >= 0.2 && < 0.4' \
		'attoparsec >= 0.10 && < 0.12' 'attoparsec >= 0.10 && < 0.13'
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag embed_data_files embed_data_files) \
		$(cabal_flag http-conduit http-conduit)
}
