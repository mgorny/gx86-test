# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="Simple (or small or suckless) X Image Viewer"
HOMEPAGE="https://github.com/muennich/sxiv/"
SRC_URI="https://github.com/muennich/sxiv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-libs/giflib
	media-libs/imlib2[X]
	x11-libs/libX11"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1-makefile.patch
	tc-export CC

	restore_config config.h
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
	dodoc README.md

	save_config config.h
}
