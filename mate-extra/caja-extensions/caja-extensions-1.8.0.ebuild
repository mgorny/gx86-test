# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Several Caja extensions"
HOMEPAGE="http://www.mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

SENDTO="cdr gajim +mail pidgin upnp"
IUSE="image-converter +open-terminal share ${SENDTO}"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.26:2
	>=mate-base/caja-1.8:0
	virtual/libintl:0
	x11-libs/gdk-pixbuf:2
	open-terminal? ( >=mate-base/mate-desktop-1.8:0 )
	cdr? ( >=app-cdr/brasero-2.32.1:0= )
	gajim? (
		net-im/gajim:0
		>=dev-libs/dbus-glib-0.60:0
		>=sys-apps/dbus-1:0
	)
	pidgin? (
		>=dev-libs/dbus-glib-0.60:0
	)
	upnp? ( >=net-libs/gupnp-0.13:0= )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.18:*
	>=mate-base/mate-common-1.8:0
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!mate-extra/mate-file-manager-open-terminal
	!!mate-extra/mate-file-manager-sendto
	!!mate-extra/mate-file-manager-image-converter
	!!mate-extra/mate-file-manager-share"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8.0-sendto-options.patch"

	eautoreconf
}

src_configure() {
	MY_CONF=""

	if use cdr || use mail || use pidgin || use gajim || use upnp ; then
		MY_CONF="${MY_CONF} --enable-sendto"
		MY_CONF="${MY_CONF} --with-sendto-plugins=removable-devices"
		use cdr && MY_CONF="${MY_CONF},caja-burn"
		use mail && MY_CONF="${MY_CONF},emailclient"
		use pidgin && MY_CONF="${MY_CONF},pidgin"
		use gajim && MY_CONF="${MY_CONF},gajim"
		use upnp && MY_CONF="${MY_CONF},upnp"
	else
		MYCONF="${MY_CONF} --disable-sendto"
	fi

	gnome2_src_configure ${MY_CONF} \
		--disable-gksu \
		$(use_enable image-converter) \
		$(use_enable open-terminal) \
		$(use_enable share)
}

DOCS="AUTHORS ChangeLog NEWS README"
