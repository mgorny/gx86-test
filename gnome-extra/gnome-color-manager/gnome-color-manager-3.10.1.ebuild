# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="http://projects.gnome.org/gnome-color-manager/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="clutter packagekit raw"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
COMMON_DEPEND="
	>=dev-libs/glib-2.31.10:2
	gnome-base/gnome-desktop:3=
	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff

	x11-libs/libX11
	x11-libs/libXrandr
	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/vte-0.25.1:2.90
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/colord-gtk-0.1.20

	clutter? (
		>=media-libs/clutter-1.12:1.0
		media-libs/clutter-gtk:1.0
		media-libs/mash:0.2 )
	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2 )
"
RDEPEND="${COMMON_DEPEND}"

# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

# FIXME: run test-suite with files on live file-system
RESTRICT="test"

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	gnome2_src_configure \
		--disable-static \
		--enable-tests \
		$(use_enable clutter) \
		$(use_enable packagekit) \
		$(use_enable raw exiv) \
		ITSTOOL=$(type -P true)
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}
