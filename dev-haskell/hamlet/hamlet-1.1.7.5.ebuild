# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Haml-like template files that are compile-time checked"
HOMEPAGE="http://www.yesodweb.com/book/shakespearean-templates"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

# unexpected '&'
# expecting end of input, "\n" or "\r\n"
RESTRICT=test
CABAL_EXTRA_CONFIGURE_FLAGS+=" --disable-tests"

RDEPEND=">=dev-haskell/blaze-builder-0.2:=[profile?] <dev-haskell/blaze-builder-0.4:=[profile?]
	>=dev-haskell/blaze-html-0.5:=[profile?]
	>=dev-haskell/blaze-markup-0.5.1:=[profile?]
	>=dev-haskell/failure-0.1:=[profile?] <dev-haskell/failure-0.3:=[profile?]
	>=dev-haskell/parsec-2:=[profile?] <dev-haskell/parsec-4:=[profile?]
	>=dev-haskell/shakespeare-1.0.1:=[profile?] <dev-haskell/shakespeare-1.3:=[profile?]
	>=dev-haskell/text-0.7:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/hspec-1.3
		dev-haskell/hunit )
"
