# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit cmake-utils vcs-snapshot

if [[ ${PV} != 9999* ]]; then
	COMMIT="780d451afad21a22d2af6bd030ee71311856f038"
	SRC_URI="https://github.com/FreeRDP/FreeRDP/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm ppc ppc64 x86"
else
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/FreeRDP/FreeRDP.git
		https://github.com/FreeRDP/FreeRDP.git"
	KEYWORDS=""
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="alsa +channels +client cups debug directfb doc ffmpeg gstreamer jpeg
	pulseaudio server smartcard sse2 test X xinerama xv"

RDEPEND="
	dev-libs/openssl
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	client? (
		X? (
			x11-libs/libXcursor
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			xinerama? ( x11-libs/libXinerama )
			xv? ( x11-libs/libXv )
		)
	)
	directfb? ( dev-libs/DirectFB )
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
		x11-libs/libXrandr
	)
	jpeg? ( virtual/jpeg )
	pulseaudio? ( media-sound/pulseaudio )
	server? (
		X? (
			x11-libs/libXcursor
			x11-libs/libXdamage
			x11-libs/libXext
			x11-libs/libXfixes
			xinerama? ( x11-libs/libXinerama )
		)
	)
	smartcard? ( sys-apps/pcsc-lite )
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
	)
"
DEPEND="${RDEPEND}
	client? ( X? ( doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	) ) )
"

DOCS=( README )

PATCHES=(
	"${FILESDIR}/${P}-ffmpeg.patch"
	"${FILESDIR}/${PN}-1.1-CVE-2014-0250.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with alsa ALSA)
		$(cmake-utils_use_with channels CHANNELS)
		$(cmake-utils_use_with client CLIENT)
		$(cmake-utils_use_with cups CUPS)
		$(cmake-utils_use_with debug DEBUG_ALL)
		$(cmake-utils_use_with doc MANPAGES)
		$(cmake-utils_use_with directfb DIRECTFB)
		$(cmake-utils_use_with ffmpeg FFMPEG)
		$(cmake-utils_use_with gstreamer GSTREAMER)
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with pulseaudio PULSE)
		$(cmake-utils_use_with server SERVER)
		$(cmake-utils_use_with smartcard PCSC)
		$(cmake-utils_use_with sse2 SSE2)
		$(cmake-utils_use_with X X11)
		$(cmake-utils_use_with xinerama XINERAMA)
		$(cmake-utils_use_with xv XV)
		$(cmake-utils_use_build test TESTING)
	)
	cmake-utils_src_configure
}
