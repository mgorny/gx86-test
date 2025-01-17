# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Mutable hash tables in the ST monad"
HOMEPAGE="http://github.com/gregorycollins/hashtables"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/hashable-1.1:=[profile?]
		<dev-haskell/hashable-2:=[profile?]
		dev-haskell/primitive:=[profile?]
		>=dev-haskell/vector-0.7:=[profile?]
		<dev-haskell/vector-0.11:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-portable \
		--flag=-sse41 \
		--flag=-debug \
		--flag=-bounds-checking \
		--flag=unsafe-tricks
}
