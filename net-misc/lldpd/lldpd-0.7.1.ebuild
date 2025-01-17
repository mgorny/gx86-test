# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils user

DESCRIPTION="Implementation of IEEE 802.1ab (LLDP)"
HOMEPAGE="http://vincentbernat.github.com/lldpd/"
SRC_URI="http://media.luffy.cx/files/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cdp doc +dot1 +dot3 edp fdp graph json +lldpmed sonmp snmp readline xml"

RDEPEND=">=dev-libs/libevent-2.0.5
		snmp? ( net-analyzer/net-snmp[extensible(+)] )
		xml? ( dev-libs/libxml2 )
		json? ( dev-libs/jansson )"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		doc? (
			graph? ( app-doc/doxygen[dot] )
			!graph? ( app-doc/doxygen )
		)"

REQUIRED_USE="graph? ( doc )"

pkg_setup() {
	ebegin "Creating lldpd user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend $?
}

src_prepare() {
	# remove the bundled libevent
	rm -rf libevent

	epatch_user
}

src_configure() {
	econf \
		--with-privsep-user=${PN} \
		--with-privsep-group=${PN} \
		--with-privsep-chroot=/var/lib/${PN} \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable graph doxygen-dot) \
		$(use_enable doc doxygen-man) \
		$(use_enable doc doxygen-pdf) \
		$(use_enable doc doxygen-html) \
		$(use_enable cdp) \
		$(use_enable dot1) \
		$(use_enable dot3) \
		$(use_enable edp) \
		$(use_enable fdp) \
		$(use_enable lldpmed) \
		$(use_enable sonmp) \
		$(use_with json) \
		$(use_with readline) \
		$(use_with snmp) \
		$(use_with xml)
}

src_compile() {
	emake
	use doc && emake doxygen-doc
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/${PN}-initd-1 ${PN}
	newconfd "${FILESDIR}"/${PN}-confd-1 ${PN}

	use doc && dohtml -r doxygen/html/*

	keepdir /var/lib/${PN}
}
