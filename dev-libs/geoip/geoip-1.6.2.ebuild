# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit autotools eutils

DESCRIPTION="easily lookup countries by IP addresses, even when Reverse DNS entries don't exist"
HOMEPAGE="https://github.com/maxmind/geoip-api-c"
SRC_URI="
	https://github.com/maxmind/${PN}-api-c/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

# GPL-2 for md5.c - part of libGeoIPUpdate, MaxMind for GeoLite Country db
LICENSE="LGPL-2.1 GPL-2 MaxMind2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"
RESTRICT="test"

DEPEND="net-misc/wget"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-api-c-${PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
	sed -e "s|@PREFIX@|${ROOT}|g" "${FILESDIR}"/geoipupdate-r4.sh > geoipupdate.sh || die
}

src_install() {
	default

	dodoc AUTHORS ChangeLog README* TODO

	prune_libtool_files

	keepdir /usr/share/GeoIP

	dosbin geoipupdate.sh
}

pkg_postinst() {
	elog "Don't forget to run the included geoipupdate.sh or geoipupdate (from"
	elog "net-misc/geoipupdate) regularly to populate ${ROOT}/usr/share/GeoIP/"
	elog "with geo-located IP address databases."
}
