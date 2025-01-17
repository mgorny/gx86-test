# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Rime Input Method Engine for IBus Framework"
HOMEPAGE="http://code.google.com/p/rimeime/"
SRC_URI="http://dl.bintray.com/lotem/rime/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="app-i18n/ibus
	app-i18n/librime
	x11-libs/libnotify"
DEPEND="${COMMON_DEPEND}
	dev-util/cmake"
RDEPEND="${COMMON_DEPEND}
	app-i18n/rime-data"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i -e "/^libexecdir/s:/lib:/libexec:" Makefile || die
	sed -i -e "/exec/s:/usr/lib:/usr/libexec:" rime.xml || die
}
