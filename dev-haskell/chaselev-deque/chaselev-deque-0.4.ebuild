# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="lib profile test-suite" # haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Chase & Lev work-stealing lock-free double-ended queues (deques)"
HOMEPAGE="https://github.com/rrnewton/haskell-lockfree-queue/wiki"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RESTRICT=test # missing files

RDEPEND=">=dev-haskell/abstract-deque-0.2.2:=[profile?] <dev-haskell/abstract-deque-0.3:=[profile?]
	>=dev-haskell/atomic-primops-0.4:=[profile?] <dev-haskell/atomic-primops-0.5:=[profile?]
	dev-haskell/bits-atomic:=[profile?]
	dev-haskell/transformers:=[profile?]
	dev-haskell/vector:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( dev-haskell/hunit
		dev-haskell/test-framework
		dev-haskell/test-framework-hunit )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag debug debug) \
		--disable-tests
}
