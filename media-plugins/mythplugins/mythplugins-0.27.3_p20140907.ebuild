# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_DEPEND="2:2.6"
BACKPORTS="2d4a7c9235287b0589035974bff282e3f2e9a7e5"
MY_P=${P%_p*}

inherit eutils python

DESCRIPTION="Official MythTV plugins"
HOMEPAGE="http://www.mythtv.org"
SRC_URI="https://github.com/MythTV/mythtv/archive/v0.27.3.tar.gz -> mythtv-0.27.3.tar.gz
	${BACKPORTS:+http://dev.gentoo.org/~rich0/distfiles/${MY_P}-${BACKPORTS}.tar.xz}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MYTHPLUGINS="mytharchive mythbrowser mythgallery mythgame \
mythmusic mythnetvision mythnews mythweather mythzoneminder"

IUSE="${MYTHPLUGINS} alsa cdda cdr exif fftw hls ieee1394 libass raw theora vorbis xml xvid"

DEPEND="!media-plugins/mytharchive
	!media-plugins/mythbrowser
	!media-plugins/mythgallery
	!media-plugins/mythgame
	!media-plugins/mythmovies
	!media-plugins/mythmusic
	!media-plugins/mythnetvision
	!media-plugins/mythnews
	!media-plugins/mythweather
	=media-tv/mythtv-${PV}*:=[alsa=,hls=,ieee1394=,libass=,python,theora=,vorbis=,xml=,xvid=]
	dev-libs/glib:=
	xml? ( >=dev-libs/libxml2-2.6.0:= )
	dev-qt/qtcore:=
	dev-qt/qtgui:=
	dev-qt/qtopengl:=
	dev-qt/qtsql:=
	dev-libs/openssl:=
	alsa? ( >=media-libs/alsa-lib-1.0.24:= )
	hls? (
		media-libs/faac:=
		media-libs/libvpx:=
		>=media-libs/x264-0.0.20111220:=
		>=media-sound/lame-3.93.1
	)
	media-libs/freetype:=
	libass? ( >=media-libs/libass-0.9.11:= )
	media-libs/libpng:=
	theora? ( media-libs/libtheora:= media-libs/libogg:= )
	vorbis? ( media-libs/libogg:= )
	xvid? ( >=media-libs/xvid-1.1.0:= )
	virtual/libudev:=
	ieee1394? (
		>=sys-libs/libraw1394-1.2.0:=
		>=sys-libs/libavc1394-0.5.3:=
		>=media-libs/libiec61883-1.0.0:=
	)
	x11-libs/libX11:=
	sys-libs/zlib:=
	x11-libs/libXext:=
	x11-libs/libXinerama:=
	x11-libs/libXrandr:=
	x11-libs/libXv:=
	x11-libs/libXxf86vm:=
	fftw? ( sci-libs/fftw:= )
	sys-apps/util-linux:=
	mythzoneminder? ( virtual/mysql:= )
	mytharchive? (
		app-cdr/dvd+rw-tools
		virtual/python-imaging:=
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/transcode
		virtual/cdrtools
	)
	mythgallery? (
		media-libs/tiff:=
		virtual/opengl
		exif? ( >media-libs/libexif-0.6.9:= )
		raw? ( media-gfx/dcraw )
	)
	mythmusic? (
		>=media-libs/flac-1.1.2:=
		>=media-libs/taglib-1.6:=
		vorbis? ( >=media-libs/libvorbis-1.0:= )
		virtual/opengl
		cdda? (
			dev-libs/libcdio:=
			cdr? ( virtual/cdrtools )
		)

	)
	mythnetvision? (
		=dev-lang/python-2*:=[xml]
		dev-python/lxml:=
		dev-python/mysql-python:=
		dev-python/oauth:=
		dev-python/pycurl:=
	)
	mythweather? (
		dev-perl/DateManip
		dev-perl/DateTime-Format-ISO8601
		>=dev-perl/DateTime-1
		dev-perl/ImageSize
		dev-perl/JSON
		dev-perl/SOAP-Lite
		dev-perl/XML-Simple
		dev-perl/XML-Parser
		dev-perl/XML-SAX
		dev-perl/XML-XPath
	)
	mythbrowser? (
		dev-qt/qtwebkit:=
	)"
RDEPEND="${DEPEND}"

REQUIRED_USE="
	cdda? ( mythmusic )
	cdr? ( mythmusic cdda )
	exif? ( mythgallery )
	fftw? ( mythmusic )
	mythnews? ( mythbrowser )
	raw? ( mythgallery )"

S="${WORKDIR}/mythtv-0.27.3/mythplugins"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${WORKDIR}/${MY_P}/patches" \
			epatch

	epatch_user
}

src_configure() {
	./configure \
		--prefix=/usr \
		--python=python2 \
		--enable-opengl \
		$(use_enable mythzoneminder) \
		$(use_enable mytharchive) \
		$(use_enable mythbrowser) \
		$(use_enable mythgallery) \
		$(use_enable mythgame) \
		$(use_enable mythmusic) \
		$(use_enable mythnetvision) \
		$(use_enable mythnews) \
		$(use_enable mythweather) \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable raw dcraw) \
		|| die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}
