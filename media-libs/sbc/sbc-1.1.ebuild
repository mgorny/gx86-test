# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils

DESCRIPTION="An audio codec to connect bluetooth high quality audio devices like headphones or loudspeakers"
HOMEPAGE="http://git.kernel.org/?p=bluetooth/sbc.git http://www.bluez.org/sbc-10/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 x86"
IUSE="static-libs"

# --enable-tester is building src/sbctester but the tarball is missing required
# .wav file to execute it
RESTRICT="test"

DEPEND="virtual/pkgconfig"

DOCS="AUTHORS ChangeLog"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-tester
}

src_install() {
	default
	prune_libtool_files
}
