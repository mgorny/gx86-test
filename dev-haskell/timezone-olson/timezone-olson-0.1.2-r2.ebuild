# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="A pure Haskell parser and renderer for binary Olson timezone files"
HOMEPAGE="http://projects.haskell.org/time-ng/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/binary-0.4.1:=[profile?]
		<dev-haskell/binary-0.8:=[profile?]
		>=dev-haskell/extensible-exceptions-0.1.0:=[profile?]
		<dev-haskell/extensible-exceptions-0.2:=[profile?]
		>=dev-haskell/timezone-series-0.1.0:=[profile?]
		<dev-haskell/timezone-series-0.2:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

src_prepare() {
	cabal_chdeps \
		'binary >= 0.4.1 && < 0.6' 'binary >= 0.4.1 && < 0.8'
}
