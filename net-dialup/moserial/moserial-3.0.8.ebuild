# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A clean and friendly gtk-based serial terminal"
HOMEPAGE="https://live.gnome.org/moserial"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16:2
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.0.0:3"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35
	virtual/pkgconfig"
