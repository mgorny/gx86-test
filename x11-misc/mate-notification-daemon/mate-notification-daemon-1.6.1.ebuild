# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE Notification daemon"
HOMEPAGE="http://mate-dekstop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-libs/atk:0
	>=dev-libs/dbus-glib-0.78:0
	>=dev-libs/glib-2.18:2
	>=media-libs/libcanberra-0.4:0[gtk]
	>=sys-apps/dbus-1:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/libmatewnck-1.6:0
	>=x11-libs/libnotify-0.7:0
	x11-libs/libX11:0
	virtual/libintl:0
	!x11-misc/notify-osd:*
	!x11-misc/qtnotifydaemon:*
	!x11-misc/notification-daemon:*"

DEPEND="${RDEPEND}
	app-arch/xz-utils:0
	>=dev-util/intltool-0.40:*
	sys-devel/gettext:*
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig:*"

DOCS=( AUTHORS ChangeLog NEWS )

src_install() {
	gnome2_src_install

	keepdir /etc/mateconf/mateconf.xml.mandatory
	keepdir /etc/mateconf/mateconf.xml.defaults

	# Make sure this directory exists.
	keepdir /etc/mateconf/mateconf.xml.system

	cat <<-EOF > "${T}/org.freedesktop.Notifications.service"
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/mate-notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}/org.freedesktop.Notifications.service"
}
