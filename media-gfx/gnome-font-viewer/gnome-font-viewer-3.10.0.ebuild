# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Font viewer for GNOME 3"
HOMEPAGE="https://live.gnome.org/GnomeUtils"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.35.1:2
	gnome-base/gnome-desktop:3=
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=x11-libs/gtk+-3.9.11:3
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-control-center-2.91
	!<gnome-extra/gnome-utils-3.4
"
# ${PN} was part of gnome-utils before 3.4, and of g-c-c before 2.91
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
