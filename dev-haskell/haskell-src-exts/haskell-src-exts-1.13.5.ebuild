# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer"
HOMEPAGE="http://code.haskell.org/haskell-src-exts"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/cpphs-1.3:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6
		dev-haskell/happy"

src_prepare() {
	# test suite is broken, expects the package to be already installed.
	# this new Setup.hs will use the package inplice for tests
	cp "${FILESDIR}/haskell-src-exts-1.10.2-Setup.hs" "${S}/Setup.hs" \
		|| die "Could not cp Setup.hs for tests"

	# remove broken tests. they will fail if you expect them to pass, and pass
	# if you expect them to fail...
	rm "${S}/Test/examples/Unicode"{.hs,Syntax.hs} \
		|| die "Could not rm broken tests"
}
