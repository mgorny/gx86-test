# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

CABAL_FEATURES="bin"
inherit haskell-cabal

DESCRIPTION="Analyze 454 flowgrams  (.SFF files)"
HOMEPAGE="http://biohaskell.org/Applications/Flower"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		>=dev-haskell/binary-0.4 <dev-haskell/binary-0.8
		>=dev-haskell/bio-0.4.9
		>=dev-haskell/cabal-1.6
		>=dev-haskell/cmdargs-0.5
		dev-haskell/mtl
		dev-haskell/random
		>=dev-lang/ghc-6.10.1"

src_prepare() {
	cabal_chdeps \
		'binary == 0.4.*' 'binary >= 0.4 && <0.8'
}
