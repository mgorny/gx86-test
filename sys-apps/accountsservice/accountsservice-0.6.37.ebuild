# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2 systemd

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/AccountsService/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~sparc x86"

IUSE="doc +introspection selinux systemd"

RDEPEND="
	>=dev-libs/glib-2.37.3:2
	sys-auth/polkit
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	selinux? ( sec-policy/selinux-accountsd )
	systemd? ( >=sys-apps/systemd-186:0= )
	!systemd? ( sys-auth/consolekit )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto )
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.6.35-gentoo-system-users.patch"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-more-warnings \
		--localstatedir="${EPREFIX}"/var \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--enable-admin-group="wheel" \
		$(use_enable doc docbook-docs) \
		$(use_enable introspection) \
		$(use_enable systemd) \
		$(systemd_with_unitdir)
}
