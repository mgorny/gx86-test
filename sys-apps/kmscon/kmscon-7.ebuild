# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
				git://people.freedesktop.org/~dvdhrm/${PN}
				git://github.com/dvdhrm/${PN}.git
				git://github.com/dvdhrm/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils autotools systemd flag-o-matic ${scm_eclass}

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/kmscon"

LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
IUSE="cairo dbus debug doc +drm +fbdev +gles2 multiseat +optimizations +pango pixman
static-libs systemd truetype udev +unicode wayland"

COMMON_DEPEND="
	dev-libs/glib:2
	>=virtual/udev-172
	x11-libs/libxkbcommon
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl,gbm] )
	truetype? ( media-libs/freetype:2 )
	gles2? ( >=media-libs/mesa-8.0.3[gles2] )
	pango? ( x11-libs/pango )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	cairo? ( x11-libs/cairo )
	pixman? ( x11-libs/pixman )
	wayland? ( dev-libs/wayland )"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="gles2? ( drm )
	multiseat? ( systemd )"

# args - names of renderers to enable
renderers_enable() {
	if [[ "x${RENDER}" == "x" ]]; then
		RENDER="$1"
		shift
	else
		for i in $@; do
			RENDER+=",${i}"
		done
	fi
}

# args - names of font renderer backends to enable
fonts_enable() {
	if [[ "x${FONTS}" == "x" ]]; then
		FONTS="$1"
		shift
	else
		for i in $@; do
			FONTS+=",${i}"
		done
	fi
}

# args - names of video backends to enable
video_enable() {
	if [[ "x${VIDEO}" == "x" ]]; then
		VIDEO="$1"
		shift
	else
		for i in $@; do
			VIDEO+=",${i}"
		done
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	# Video backends

	if use fbdev; then
		video_enable fbdev
	fi

	if use drm; then
		video_enable drm2d
	fi

	if use gles2; then
		video_enable drm3d
	fi

	# Font rendering backends 

	if use unicode; then
		fonts_enable unifont
	fi

	if use truetype; then
		fonts_enable freetype2
	fi

	if use pango; then
		fonts_enable pango
	fi

	# Console rendering backends

	renderers_enable bbulk

	if use gles2; then
		renderers_enable gltex
	fi

	if use cairo; then
		renderers_enable cairo
	fi

	if use pixman; then
		renderers_enable pixman
	fi

	# kmscon sets -ffast-math unconditionally
	strip-flags

	# xkbcommon not in portage
	econf \
		$(use_enable static-libs static) \
		$(use_enable udev hotplug) \
		$(use_enable dbus eloop-dbus) \
		$(use_enable debug) \
		$(use_enable optimizations) \
		$(use_enable multiseat multi-seat) \
		$(use_enable wayland wlterm) \
		--htmldir=/usr/share/doc/${PF}/html \
		--with-video=${VIDEO} \
		--with-fonts=${FONTS} \
		--with-renderers=${RENDER} \
		--with-sessions=dummy,terminal \
		--enable-kmscon
}

src_install() {
	emake DESTDIR="${D}" install

	if use systemd; then
		systemd_dounit "${S}/docs"/kmscon{,vt@}.service
	fi
}
