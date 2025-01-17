# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.4.9999
#hackport: flags: +separatesyb,+usebytestrings,+splitbase

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Analysis and generation of C code"
HOMEPAGE="http://www.sivity.net/projects/language.c/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/syb:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	dev-haskell/alex
	>=dev-haskell/cabal-1.6
	dev-haskell/happy
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=separatesyb \
		--flag=splitbase \
		--flag=usebytestrings
}
