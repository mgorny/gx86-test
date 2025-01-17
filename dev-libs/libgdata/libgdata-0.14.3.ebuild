# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/13" # subslot = libgdata soname version
IUSE="gnome +introspection static-libs vala"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
REQUIRED_IUSE="vala? ( introspection )"

# gtk+ is needed for gdk
# configure checks for gtk:3, but only uses it for demos which are not installed
RDEPEND="
	>=dev-libs/glib-2.31:2
	>=dev-libs/libxml2-2:2
	>=net-libs/liboauth-0.9.4
	>=net-libs/libsoup-2.42.0:2.4[introspection?]
	>=x11-libs/gdk-pixbuf-2.14:2
	gnome? (
		app-crypt/gcr:=
		>=net-libs/gnome-online-accounts-3.2 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40
	>=gnome-base/gnome-common-3.6
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	# Disable tests requiring network access, bug #307725
	sed -e '/^TEST_PROGS = / s:\(.*\):TEST_PROGS = general perf calendar client-login-authorizer contacts documents oauth1-authorizer picasaweb youtube \nOLD_\1:' \
		-i gdata/tests/Makefile.in || die "network test disable failed"

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_configure \
		$(use_enable gnome) \
		$(use_enable gnome goa) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable static-libs static)
}

src_test() {
	unset ORBIT_SOCKETDIR
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch emake check || die "emake check failed"
}
