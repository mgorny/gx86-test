# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

IUSE=""

MY_PN=${PN/-a/.A}
MY_PN=${MY_PN/xs/XS}
MY_PN=${MY_PN/s/S}
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="XScreenSaver dockapp for the Window Maker window manager"
SRC_URI=" http://www.asleep.net/download/${MY_PN}-${PV}.tar.gz"
HOMEPAGE="http://xscreensaverapp.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="x11-misc/xscreensaver"
DEPEND="x11-libs/libdockapp"

src_compile() {
	econf || die "Configuration failed"
	emake || die "Make Failed"
}

src_install () {
	einstall || die "Install failed"
	dodoc README NEWS ChangeLog TODO AUTHORS
}
