# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Simplifies TCP/IP socket operations"
HOMEPAGE="http://www.vergenet.net/linux/vanessa/"
SRC_URI="http://www.vergenet.net/linux/perdition/download/BETA/1.11beta5/vanessa_socket-0.0.5beta4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-libs/vanessa-logger-0.0.4_beta2"

S=${WORKDIR}/vanessa_socket-0.0.5beta4

src_install() {
	einstall || die
	dodoc README NEWS AUTHORS TODO
}
