# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools eutils linux-info

DESCRIPTION="Soundcard Oscilloscope for X"
HOMEPAGE="http://xoscope.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtkdatabox
	virtual/man"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~!SND_PCM_OSS"
ERROR_SND_PCM_OSS="CONFIG_SND_PCM_OSS is needed to support sound card input via /dev/dsp"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-remove_bundled_gtkdatabox.patch \
		"${FILESDIR}"/${P}-man_no_-Tutf8.patch \
		"${FILESDIR}"/${P}-implicit_decls.patch \
		"${FILESDIR}"/${P}-comedi_compile.patch

	eautoreconf
}

src_compile() {
	emake -j1
}
