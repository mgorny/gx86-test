# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="A desktop session recorder producing Ogg video/audio files"
HOMEPAGE="http://recordmydesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="jack alsa"

DEPEND="x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libICE
	x11-libs/libSM
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libtheora[encode]
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable jack) $(use_enable !alsa oss)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README AUTHORS ChangeLog TODO
}
