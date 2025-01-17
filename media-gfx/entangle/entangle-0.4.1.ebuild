# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit gnome2

DESCRIPTION="Tethered Camera Control & Capture"
HOMEPAGE="http://entangle-photo.org/"
SRC_URI="http://entangle-photo.org/download/sources/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gdk-pixbuf-2.12.0:2
	>=x11-libs/gtk+-3.3.18:3
	virtual/libgudev:=
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/gobject-introspection-0.9.3
	>=media-libs/libgphoto2-2.4.11
	>=media-libs/lcms-1.18:0
	>=dev-libs/libpeas-0.5.5[gtk]
	>=media-libs/gexiv2-0.2.2
	>=x11-libs/libXext-1.3.0"
RDEPEND="${DEPEND}"
DEPEND+="
	virtual/pkgconfig"

G2CONF+="
	--disable-maintainer-mode
	--docdir=/usr/share/doc/${PF}
	--htmldir=/usr/share/doc/${PF}/html
	--disable-werror
	--disable-static"

DOCS=( AUTHORS ChangeLog NEWS README )
