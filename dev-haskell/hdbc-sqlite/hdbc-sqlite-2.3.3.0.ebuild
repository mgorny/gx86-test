# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

# ebuild generated by hackport 0.2.18.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="HDBC-sqlite3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sqlite v3 driver for HDBC"
HOMEPAGE="http://software.complete.org/hdbc-sqlite3"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # not all files are bundled

RDEPEND=">=dev-haskell/hdbc-2.3.0.0[profile?]
		dev-haskell/mtl[profile?]
		dev-haskell/utf8-string[profile?]
		>=dev-lang/ghc-6.10.1
		>=dev-db/sqlite-3.2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2.3
		test? ( dev-haskell/convertible
			dev-haskell/hunit
			dev-haskell/testpack
		)
	"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${MY_PN}-2.3.3.0-ghc-7.6.patch"
	cp "${FILESDIR}/TestTime.hs" "${S}/testsrc"
}

src_configure() {
	cabal_src_configure $(cabal_flag test buildtests)
}

src_test() {
	# default tests
	haskell-cabal_src_test || die "cabal test failed"

	# built custom tests
	"${S}/dist/build/runtests/runtests" || die "unit tests failed"
}

src_install() {
	cabal_src_install

	# if tests were enabled, make sure the unit test driver is deleted
	rm -f "${ED}/usr/bin/runtests"
}
