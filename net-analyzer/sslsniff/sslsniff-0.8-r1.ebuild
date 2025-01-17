# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_DEPEND="2"

inherit autotools eutils

DESCRIPTION="MITM all SSL connections on a LAN and dynamically generates certs"
HOMEPAGE="http://thoughtcrime.org/software/sslsniff/"
SRC_URI="http://thoughtcrime.org/software/sslsniff/${P}.tar.gz"

LICENSE="GPL-3" # plus OpenSSL exception
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost:=
	dev-libs/log4cpp
	dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6-asneeded.patch

	#stolen from http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=652756
	epatch \
		"${FILESDIR}"/${P}-fix-compatibility-with-boost-1.47-and-higher.patch \
		"${FILESDIR}"/${P}-underlinking.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README

	insinto /usr/share/sslsniff
	doins leafcert.pem IPSCACLASEA1.crt

	insinto /usr/share/sslsniff/updates
	doins updates/*xml

	insinto /usr/share/sslsniff/certs
	doins certs/*
}
