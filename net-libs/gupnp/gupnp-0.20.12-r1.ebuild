# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"
# FIXME: Claims to works with python3 but appears to be wishful thinking
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="xml"

inherit gnome2 multilib-minimal python-r1 vala

DESCRIPTION="An object-oriented framework for creating UPnP devs and control points"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2"
SLOT="0/4"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="connman +introspection kernel_linux networkmanager"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( connman networkmanager )"

RDEPEND="
	${PYTHON_DEPS}
	>=net-libs/gssdp-0.14.7:0=[introspection?,${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.44.2:2.4[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	|| (
		>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
		<sys-libs/e2fsprogs-libs-1.41.8[${MULTILIB_USEDEP}] )
	introspection? (
			>=dev-libs/gobject-introspection-0.6.4
			$(vala_depend) )
	connman? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	networkmanager? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	!net-libs/gupnp-vala
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	use introspection && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	local backend=unix
	use kernel_linux && backend=linux
	use connman && backend=connman
	use networkmanager && backend=network-manager

	# fake connman.pc to avoid pulling it in unnecessarily (only dbus
	# interface is used) and fix multilib. [fixed in vcs]
	# https://bugzilla.gnome.org/show_bug.cgi?id=731457

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		CONNMAN_CFLAGS=' ' CONNMAN_LIBS=' ' \
		$(multilib_native_use_enable introspection) \
		--disable-static \
		--with-context-manager=${backend}

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	einstalldocs
	python_parallel_foreach_impl python_doscript tools/gupnp-binding-tool
}
