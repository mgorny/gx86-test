# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Music Player For Console"
HOMEPAGE="http://mpfc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa cdda flac gpm mad nls oss static-libs vorbis wav"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.9.0 )
	flac? ( media-libs/flac )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	sys-libs/ncurses[unicode]
	dev-libs/icu:="
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable alsa) \
		$(use_enable cdda audiocd) \
		$(use_enable flac) \
		$(use_enable gpm) \
		$(use_enable mad mp3) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable static-libs static) \
		$(use_enable vorbis ogg) \
		$(use_enable wav)
}

src_install() {
	default

	insinto /etc
	doins mpfcrc

	find "${D}" -name '*.la' -delete || die
}
