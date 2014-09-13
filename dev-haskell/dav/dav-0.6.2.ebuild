# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.4.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="DAV"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="RFC 4918 WebDAV support"
HOMEPAGE="http://floss.scru.org/hDAV"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/case-insensitive-0.4:=[profile?]
	>=dev-haskell/either-4.1:=[profile?]
	dev-haskell/errors:=[profile?]
	>=dev-haskell/http-client-0.2:=[profile?]
	>=dev-haskell/http-client-tls-0.2:=[profile?]
	>=dev-haskell/http-types-0.7:=[profile?]
	>=dev-haskell/lens-3.0:=[profile?]
	>=dev-haskell/lifted-base-0.1:=[profile?]
	>=dev-haskell/monad-control-0.3.2:=[profile?]
	>=dev-haskell/mtl-2.1:=[profile?]
	>=dev-haskell/network-2.3:=[profile?]
	>=dev-haskell/optparse-applicative-0.5.0:=[profile?]
	>=dev-haskell/transformers-0.3:=[profile?]
	dev-haskell/transformers-base:=[profile?]
	>=dev-haskell/xml-conduit-1.0:=[profile?] <dev-haskell/xml-conduit-1.3:=[profile?]
	>=dev-haskell/xml-hamlet-0.4:=[profile?] <=dev-haskell/xml-hamlet-0.5:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

S="${WORKDIR}/${MY_P}"
