# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit eutils multilib flag-o-matic

DESCRIPTION="Lightweight audio player"
HOMEPAGE="http://code.google.com/p/gejengel"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+alsa audioscrobbler debug dbus +ffmpeg flac libnotify mad openal pulseaudio syslog"

RDEPEND="dev-cpp/gtkmm:2.4
	dev-cpp/pangomm:1.4
	media-libs/taglib
	dev-db/sqlite:3
	|| ( media-gfx/imagemagick[cxx]
	media-gfx/graphicsmagick[imagemagick] )
	mad? ( media-libs/libmad )
	flac? ( media-libs/flac[cxx] )
	ffmpeg? ( virtual/ffmpeg )
	audioscrobbler? ( >=media-libs/lastfmlib-0.4 )
	dbus? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )
	openal? ( media-libs/openal )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	dev-libs/libxdg-basedir
	dev-util/intltool
	>=sys-devel/automake-1.11"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch \
		"${FILESDIR}"/${P}-ffmpeg.patch \
		"${FILESDIR}"/${P}-ffmpeg-1.patch \
		"${FILESDIR}"/${P}-libav9.patch
	# Remove Vesion and Encoding from the desktop file
	sed -i -e "/Version/d" -e "/Encoding/d" \
		data/${PN}.desktop.in || die "sed failed"
	append-cxxflags "-D__STDC_CONSTANT_MACROS"
}

src_configure() {
	econf \
		--disable-shared \
		$(use_enable syslog logging) \
		$(use_enable debug) \
		$(use_enable openal) \
		$(use_enable audioscrobbler lastfm) \
		$(use_enable dbus) \
		$(use_enable libnotify) \
		$(use_enable mad) \
		$(use_enable flac) \
		$(use_enable ffmpeg) \
		$(use_enable alsa) \
		$(use_enable pulseaudio) \
		--disable-unittests
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	default
	# The libgejengel.a is used by the package when building but shouldn't end
	# up in the installation target
	rm -f "${ED}"usr/$(get_libdir)/libgejengel.{a,la}
}
