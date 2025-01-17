# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

DESCRIPTION="ssh-lpr backend for cups -- print to remote systems over ssh"
HOMEPAGE="http://www.masella.name/technical/sshlpr.html"
SRC_URI="http://dev.gentoo.org/~radhermit/distfiles/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}
	net-misc/openssh
	sys-apps/shadow"

S="${WORKDIR}"

src_install() {
	exeinto $(cups-config --serverbin)/backend
	exeopts -m0700
	doexe ${PN}
}
