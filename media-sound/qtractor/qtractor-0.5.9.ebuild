# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit qt4-r2 flag-o-matic

DESCRIPTION="Qtractor is an Audio/MIDI multi-track sequencer"
HOMEPAGE="http://qtractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug dssi libsamplerate mad osc rubberband vorbis sse zlib"

RDEPEND=">=dev-qt/qtcore-4.2:4
	>=dev-qt/qtgui-4.7:4
	media-libs/alsa-lib
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	media-libs/lilv
	media-libs/lv2
	media-libs/suil
	dssi? ( media-libs/dssi )
	mad? ( media-libs/libmad )
	libsamplerate? ( media-libs/libsamplerate )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README ChangeLog TODO AUTHORS"

src_configure() {
	econf \
		$(use_enable mad libmad) \
		$(use_enable libsamplerate) \
		$(use_enable vorbis libvorbis) \
		$(use_enable osc liblo) \
		--enable-ladspa \
		$(use_enable dssi) \
		--enable-lilv \
		$(use_enable rubberband librubberband) \
		$(use_enable sse) \
		$(use_enable zlib libz) \
		$(use_enable debug)
	eqmake4 qtractor.pro -o qtractor.mak
}
