# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Software Transactional Memory"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.12.1"

DEPEND="$RDEPEND
		>=dev-haskell/cabal-1.2"
