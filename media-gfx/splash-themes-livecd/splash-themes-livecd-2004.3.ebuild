# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

S="${WORKDIR}/livecd-${PV}"
DESCRIPTION="Gentoo theme for gensplash consoles"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/${PN}/${PF}.tar.bz2"

SLOT=${PV}
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="media-gfx/splashutils"

src_install() {
	dodir /etc/splash/livecd-${PV}
	cp -r "${S}"/* "${D}"/etc/splash/livecd-${PV}
}
