# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="JSON pretty-printing library and command-line tool"
HOMEPAGE="http://github.com/informatikr/aeson-pretty"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="lib-only"

RDEPEND=">=dev-haskell/aeson-0.6:=[profile?]
	>=dev-haskell/text-0.11:=[profile?]
	>=dev-haskell/unordered-containers-0.1.3.0:=[profile?]
	>=dev-haskell/vector-0.9:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	!lib-only? ( >=dev-haskell/attoparsec-0.10:=[profile?]
			>=dev-haskell/cmdargs-0.7:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag lib-only lib-only)
}
