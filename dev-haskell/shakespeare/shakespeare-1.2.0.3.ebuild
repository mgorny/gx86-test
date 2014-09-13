# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A toolkit for making compile-time interpolated templates"
HOMEPAGE="http://www.yesodweb.com/book/shakespearean-templates"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="test_export"

RDEPEND=">=dev-haskell/parsec-2:=[profile?] <dev-haskell/parsec-4:=[profile?]
	>=dev-haskell/system-fileio-0.3:=[profile?]
	>=dev-haskell/system-filepath-0.4:=[profile?]
	>=dev-haskell/text-0.7:=[profile?]
	>=dev-lang/ghc-6.12.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
	test? ( >=dev-haskell/hspec-1.3 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag test_export test_export)
}
