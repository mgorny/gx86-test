# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.6.9999
#hackport: flags: -decoderinterface

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="SHA"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Implementations of the SHA suite of message digest functions"
HOMEPAGE="http://hackage.haskell.org/package/SHA"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="exe"

RDEPEND=">=dev-haskell/binary-0.7:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	haskell-cabal_src_configure \
		--flag=decoderinterface \
		$(cabal_flag exe exe)
}
