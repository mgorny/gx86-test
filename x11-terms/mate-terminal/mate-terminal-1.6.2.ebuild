# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

GCONF_DEBUG="no"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="The MATE Terminal"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.25:2
	>=gnome-base/dconf-0.10:0
	>=mate-base/mate-desktop-1.6:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.18:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/pango:0
	>=x11-libs/vte-0.25.91:0"

DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.6:0
	>=app-text/scrollkeeper-dtd-1:1.0
	|| (
		dev-util/gtk-builder-convert:0
		<=x11-libs/gtk+-2.24.10:2
	)
	>=dev-util/intltool-0.40:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

DOCS="AUTHORS ChangeLog HACKING NEWS README"
