# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.6.9999

CABAL_FEATURES="bin test-suite"
inherit haskell-cabal

DESCRIPTION="Draw pretty sequence diagrams of D-Bus traffic"
HOMEPAGE="http://hackage.haskell.org/package/bustle"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2" # bustle-dbus-monitor.c is GPL-2, rest is LGPL-2
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	net-libs/libpcap
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/pango
	gnome-base/libglade:2.0"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
	dev-haskell/cairo
	>=dev-haskell/dbus-0.10
	dev-haskell/glib
	>=dev-haskell/gtk-0.12.4
	dev-haskell/mtl
	dev-haskell/pango
	dev-haskell/parsec
	dev-haskell/pcap
	dev-haskell/text
	>=dev-lang/ghc-6.12.1
	virtual/pkgconfig
	test? ( dev-haskell/hunit
		dev-haskell/quickcheck
		dev-haskell/test-framework
		dev-haskell/test-framework-hunit )
"

src_compile() {
	# compile haskell part
	cabal_src_compile || die "could not build haskell parts"

	# compile C part
	emake \
		"CC=$(tc-getCC)" \
		"CFLAGS=${CFLAGS}" \
		"CPPFLAGS=${CPPFLAGS}" \
		"LDFLAGS=${LDFLAGS}"
}

src_install() {
	# install haskell part
	cabal_src_install || die "could not install haskell parts"

	dobin "${S}"/dist/build/bustle-pcap
	doman bustle-pcap.1
	dodoc README HACKING NEWS
}
