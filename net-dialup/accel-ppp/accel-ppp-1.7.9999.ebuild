# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

EGIT_REPO_URI="git://accel-ppp.git.sourceforge.net/gitroot/accel-ppp/accel-ppp"
EGIT_BRANCH="1.7"
inherit cmake-utils git-r3 linux-info multilib

DESCRIPTION="High performance PPTP, PPPoE and L2TP server"
HOMEPAGE="http://accel-ppp.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc postgres radius shaper snmp valgrind"

RDEPEND="postgres? ( dev-db/postgresql-base )
	snmp? ( net-analyzer/net-snmp )
	dev-libs/libpcre
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"

DOCS=( README )
CONFIG_CHECK="~L2TP ~PPPOE ~PPTP"

src_prepare() {
	sed -i  -e "/mkdir/d" \
		-e "/echo/d" \
		-e "s: RENAME accel-ppp.conf.dist::" accel-pppd/CMakeLists.txt || die 'sed on accel-pppd/CMakeLists.txt failed'

	# TBF shaper is obsolete by upstream, so it's disabled
	sed -i -e '/IF (SHAPER)/s/SHAPER/SHAPER_TBF/' \
		accel-pppd/extra/CMakeLists.txt || die 'sed on accel-pppd/extra/CMakeLists.txt failed'

	epatch_user
}

src_configure() {
	local libdir="$(get_libdir)"
	# There must be also dev-libs/tomcrypt (TOMCRYPT) as crypto alternative to OpenSSL
	local mycmakeargs=(
		-DLIB_PATH_SUFFIX="${libdir#lib}"
		-DBUILD_DRIVER=FALSE
		-DCRYPTO=OPENSSL
		$(cmake-utils_use debug MEMDEBUG)
		$(cmake-utils_use postgres LOG_PGSQL)
		$(cmake-utils_use radius RADIUS)
		$(cmake-utils_use shaper SHAPER)
		$(cmake-utils_use snmp NETSNMP)
		$(cmake-utils_use valgrind VALGRIND)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r rfc

	if use snmp; then
		insinto /usr/share/snmp/mibs
		doins accel-pppd/extra/net-snmp/ACCEL-PPP-MIB.txt
	fi

	newinitd "${FILESDIR}"/${PN}.initd ${PN}d
	newconfd "${FILESDIR}"/${PN}.confd ${PN}d

	dodir /var/log/accel-ppp
}
