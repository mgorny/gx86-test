# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="TLS OpenSSL extension to Tcl"
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="mirror://sourceforge/tls/${PN}${PV}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="tk"

DEPEND="
	dev-lang/tcl
	dev-libs/openssl
	tk? ( dev-lang/tk )"
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${PN}${PV%.*}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-bad-version.patch

}

src_compile() {
	econf --with-ssl-dir=/usr
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog README.txt || die
	dohtml tls.htm || die
}
