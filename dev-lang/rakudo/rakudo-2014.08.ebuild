# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PARROT_VERSION="6.7.0"

inherit eutils multilib

DESCRIPTION="A Perl 6 implementation built on the Parrot virtual machine"
HOMEPAGE="http://rakudo.org/"
SRC_URI="http://rakudo.org/downloads/${PN}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +parrot java moar"

RDEPEND=">=dev-lang/parrot-${PARROT_VERSION}:=[unicode]
	>=dev-lang/nqp-${PV}[parrot?,java?,moar?]"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	sed -i "s,\$(DOCDIR)/rakudo$,&-${PVR}," tools/build/Makefile-Parrot.in || die
}

src_configure() {
	use parrot && myconf+="parrot,"
	use java && myconf+="jvm,"
	use moar && myconf+="moar,"
	perl Configure.pl --backends=${myconf} --prefix=/usr || die
}

src_test() {
	emake -j1 test || die
}

src_install() {
	emake -j1 DESTDIR="${ED}" install || die

	dodoc CREDITS README.md docs/ChangeLog docs/ROADMAP || die

	if use doc; then
		dohtml -A svg docs/architecture.html docs/architecture.svg || die
		dodoc docs/*.pod || die
		docinto announce
		dodoc docs/announce/* || die
	fi
}
