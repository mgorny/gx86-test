# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit autotools eutils multilib

DESCRIPTION="Circuit drawing and schematic capture program"
SRC_URI="http://opencircuitdesign.com/xcircuit/archive/${P}.tgz"
HOMEPAGE="http://opencircuitdesign.com/xcircuit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXpm
	x11-libs/libSM
	x11-libs/libICE
	sys-libs/zlib
	app-text/ghostscript-gpl
	dev-lang/tcl
	dev-lang/tk"
RDEPEND="${DEPEND}"

RESTRICT="test" #131024

src_prepare() {
	epatch "${FILESDIR}"/${P}-implicit.patch
	eautoreconf
}

src_configure() {
	export loader_run_path="/usr/$(get_libdir)"
	econf \
		--disable-dependency-tracking \
		--with-tcl \
		--with-ngspice
}

src_compile() {
	emake appdefaultsdir="/usr/share/X11/app-defaults" || die
}

src_install () {
	emake DESTDIR="${D}" appdefaultsdir="/usr/share/X11/app-defaults" \
		appmandir="/usr/share/man/man1" install || die
	dodoc CHANGES README* TODO
}
