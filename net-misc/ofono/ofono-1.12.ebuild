# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils multilib systemd

DESCRIPTION="Open Source mobile telephony (GSM/UMTS) daemon"
HOMEPAGE="http://ofono.org/"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="+atmodem bluetooth +cdmamodem +datafiles doc dundee examples +isimodem +phonesim +provision +qmimodem threads test tools +udev"

REQUIRED_USE="dundee? ( bluetooth )"

RDEPEND=">=sys-apps/dbus-1.4
	>=dev-libs/glib-2.28
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/bluez-4.99 )
	udev? ( virtual/udev )
	examples? ( dev-python/dbus-python )
	tools? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS )

src_prepare() {
	default

	epatch "${FILESDIR}"/${P}-sys-types.patch
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable udev) \
		$(use_enable isimodem) \
		$(use_enable atmodem) \
		$(use_enable cdmamodem) \
		$(use_enable datafiles) \
		$(use_enable dundee) \
		$(use_enable bluetooth) \
		$(use_enable phonesim) \
		$(use_enable provision) \
		$(use_enable qmimodem) \
		$(use_enable tools) \
		$(use_enable test) \
		--disable-maintainer-mode \
		--localstatedir=/var \
		--with-systemdunitdir="$(systemd_get_unitdir)"
}

src_install() {
	default

	if ! use examples ; then
		rm -rf "${D}/usr/$(get_libdir)/ofono/test" || die
	fi

	if use tools ; then
		dobin tools/{auto-enable,huawei-audio}
	fi

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use doc && dodoc doc/*.txt
}
