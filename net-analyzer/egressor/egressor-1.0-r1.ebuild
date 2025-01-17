# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="tool for checking router configuration"
HOMEPAGE="http://www.packetfactory.net/projects/egressor/"
SRC_URI="http://www.packetfactory.net/projects/${PN}/${PN}_release${PV}.tar.gz"

LICENSE="egressor"
SLOT="0"
IUSE=""
KEYWORDS="x86 ppc"

DEPEND="<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3"
RDEPEND="net-libs/libpcap
	dev-perl/Net-RawIP
	dev-lang/perl"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-libnet-1.0.patch
}

src_compile() {
	cd client
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin client/egressor server/egressor_server.pl
	dodoc README client/README-CLIENT server/README-SERVER
}
