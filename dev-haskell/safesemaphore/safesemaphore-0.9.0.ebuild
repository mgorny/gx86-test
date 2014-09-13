# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.1.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

MY_PN="SafeSemaphore"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Much safer replacement for QSemN, QSem, and SampleVar"
HOMEPAGE="https://github.com/ChrisKuklewicz/SafeSemaphore"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="dev-haskell/stm:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		test? ( dev-haskell/hunit
		)
		>=dev-haskell/cabal-1.8"

S="${WORKDIR}/${MY_P}"
