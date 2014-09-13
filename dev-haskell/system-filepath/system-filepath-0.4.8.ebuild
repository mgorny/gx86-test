# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="High-level, byte-based file and directory path manipulations"
HOMEPAGE="https://john-millikin.com/software/haskell-filesystem/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-haskell/deepseq-1.1:=[profile?] <dev-haskell/deepseq-1.4:=[profile?]
	>=dev-haskell/text-0.7.1:=[profile?] <dev-haskell/text-0.12:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
"
