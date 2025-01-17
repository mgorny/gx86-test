# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils

DESCRIPTION="MCU-specific data for MSP430 microcontrollers"
HOMEPAGE="http://mspgcc.sourceforge.net"
SRC_URI="mirror://sourceforge/mspgcc/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20111205-install.patch
}

src_install() {
	MSP430MCU_ROOT="${S}" ./scripts/install.sh "${D}/usr"
}
