# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="An editor to the GNOME 2 config system"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=gnome-base/gconf-2.12"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	~app-text/docbook-xml-dtd-4.1.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--with-gtk=2.0"
}
