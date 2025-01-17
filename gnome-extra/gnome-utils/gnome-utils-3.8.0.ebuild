# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

DESCRIPTION="Meta package for utilities for the GNOME desktop"
HOMEPAGE="https://live.gnome.org/GnomeUtils"

LICENSE="metapackage"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="
	>=app-admin/gnome-system-log-${PV}
	>=app-dicts/gnome-dictionary-${PV}
	>=gnome-extra/gnome-search-tool-3.6.0
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
	>=sys-apps/baobab-${PV}
"
