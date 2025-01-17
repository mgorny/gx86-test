# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils multilib qt4-r2

MY_P=${P/-/_}

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="http://users.telenet.be/on4qz/"
SRC_URI="http://users.telenet.be/on4qz/qsstv/downloads/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:4[qt3support]
	media-libs/hamlib
	media-libs/alsa-lib
	sci-libs/fftw:3.0"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
	    -e "s:local/bin:/bin:" \
		-e "s:target.extra:#target.extra:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" \
		src/src.pro || die
	sed -i -e "s:doc/qsstv:doc/${PF}:" src/configdialog.cpp || die
	# add missing #includes for gcc-4.7 (bug # 427486)
	epatch "${FILESDIR}"/${P}-gcc-47.patch
}
