# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="LXDE session manager (lite version)"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ppc x86 ~arm-linux ~x86-linux"
SLOT="0"
# upower USE flag is enabled by default in the desktop profile
IUSE="+dbus nls upower"

COMMON_DEPEND="dev-libs/glib:2
	lxde-base/lxde-common
	x11-libs/gtk+:2
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"
RDEPEND="${COMMON_DEPEND}
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"
REQUIRED_USE="upower? ( dbus )"

DOCS="AUTHORS ChangeLog README"

src_configure() {
	# dbus is used for restart/shutdown (CK, logind?), and suspend/hibernate (UPower)
	econf \
		$(use_enable dbus) \
		$(use_enable nls)
}
