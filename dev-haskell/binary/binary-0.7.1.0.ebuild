# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Binary serialisation for Haskell values using lazy ByteStrings"
HOMEPAGE="https://github.com/kolmodin/binary"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( dev-haskell/hunit
			>=dev-haskell/quickcheck-2.5
			>=dev-haskell/random-1.0.1.0
			dev-haskell/test-framework
			>=dev-haskell/test-framework-quickcheck2-0.3
		)"

CABAL_CORE_LIB_GHC_PV="7.7.2013* 7.8.20140130 7.8.0.20140228 7.8.1 7.8.2 7.8.3"

src_prepare() {
	if has_version ">=dev-lang/ghc-7.7"; then
		sed -e '/test-suite read-write-file/,/ghc-options: -Wall/d' \
			-i "${S}/${PN}.cabal" \
			|| die "Could not remove test suite for ghc 7.7"
	fi
}
