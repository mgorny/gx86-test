# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Fast combinator parsing for bytestrings and text"
HOMEPAGE="https://github.com/bos/attoparsec"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-haskell/deepseq:=[profile?]
		>=dev-haskell/text-0.11.1.5:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		test? ( >=dev-haskell/quickcheck-2.4
			>=dev-haskell/test-framework-0.4
			>=dev-haskell/test-framework-quickcheck2-0.2
		)
		>=dev-haskell/cabal-1.8"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-developer
}
