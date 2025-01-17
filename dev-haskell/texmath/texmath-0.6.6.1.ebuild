# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.6.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Conversion of LaTeX math formulas to MathML or OMML"
HOMEPAGE="http://github.com/jgm/texmath"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="cgi test"

RDEPEND="dev-haskell/pandoc-types:=[profile?]
	>=dev-haskell/parsec-3:=[profile?]
	dev-haskell/syb:=[profile?]
	dev-haskell/xml:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	cgi? ( dev-haskell/cgi:=[profile?]
		dev-haskell/json:=[profile?]
		dev-haskell/utf8-string:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag cgi cgi) \
		$(cabal_flag test test)
}
