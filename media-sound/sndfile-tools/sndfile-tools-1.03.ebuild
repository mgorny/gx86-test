# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

DESCRIPTION="A small collection of programs that use libsndfile"
HOMEPAGE="http://www.mega-nerd.com/libsndfile/tools/"
SRC_URI="http://www.mega-nerd.com/libsndfile/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=media-libs/libsndfile-1.0.19
	>=x11-libs/cairo-1.4.0
	sci-libs/fftw:3.0
	media-sound/jack-audio-connection-kit"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	econf --disable-gcc-werror
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
