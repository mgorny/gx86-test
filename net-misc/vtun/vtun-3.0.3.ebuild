# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils linux-info

DESCRIPTION="Create virtual tunnels over TCP/IP networks with traffic shaping, encryption, and compression"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://vtun.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE="lzo socks5 ssl zlib"

RDEPEND="ssl? ( dev-libs/openssl )
	lzo? ( dev-libs/lzo:2 )
	zlib? ( sys-libs/zlib )
	socks5? ( net-proxy/dante )"
DEPEND="${RDEPEND}
	sys-devel/bison"

DOCS="ChangeLog Credits FAQ README README.Setup README.Shaper TODO"

CONFIG_CHECK="~TUN"

src_prepare() {
	sed -i Makefile.in \
		-e '/^LDFLAGS/s|=|+=|g' \
		|| die "sed Makefile"
	epatch "${FILESDIR}"/${P}-includes.patch
	# remove unneeded checking for /etc/vtund.conf
	epatch "${FILESDIR}"/${PN}-3.0.2-remove-config-presence-check.patch
	# portage takes care about striping binaries itself
	sed -i 's:$(BIN_DIR)/strip $(DESTDIR)$(SBIN_DIR)/vtund::' Makefile.in
}

src_configure() {
	econf \
		$(use_enable ssl) \
		$(use_enable zlib) \
		$(use_enable lzo) \
		$(use_enable socks5 socks) \
		--enable-shaper
}

src_install() {
	default
	newinitd "${FILESDIR}"/vtun.rc vtun
	insinto etc
	doins "${FILESDIR}"/vtund-start.conf
}
