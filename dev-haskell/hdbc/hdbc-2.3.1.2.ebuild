# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.1.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal versionator

MY_PN="HDBC"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Haskell Database Connectivity"
HOMEPAGE="https://github.com/hdbc/hdbc"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="mysql odbc postgres sqlite3 test"

RDEPEND=">=dev-haskell/convertible-1.0.10.0:=[profile?]
		dev-haskell/mtl:=[profile?]
		dev-haskell/text:=[profile?]
		dev-haskell/utf8-string:=[profile?]
		>=dev-lang/ghc-6.12.1:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( dev-haskell/hunit
			dev-haskell/quickcheck
			dev-haskell/testpack
		)
	"

DEPENDV="$(get_version_component_range 1-2)"
PDEPEND="mysql? ( dev-haskell/hdbc-mysql )
		odbc? ( =dev-haskell/hdbc-odbc-${DEPENDV}* )
		postgres? ( =dev-haskell/hdbc-postgresql-${DEPENDV}* )
		sqlite3? ( >=dev-haskell/hdbc-sqlite-${DEPENDV} )"

S="${WORKDIR}/${MY_P}"

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
