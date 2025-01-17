# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit autotools eutils multilib python-any-r1 readme.gentoo systemd udev user multilib-minimal

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="cups debug +obex +readline selinux systemd test +udev"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.6:=
	>=sys-apps/hwids-20121202.2
	cups? ( net-print/cups:= )
	obex? ( dev-libs/libical )
	readline? ( sys-libs/readline:= )
	selinux? ( sec-policy/selinux-bluetooth )
	systemd? ( sys-apps/systemd )
	udev? ( >=virtual/udev-172 )
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-soundlibs-20140406-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32]
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		>=dev-python/dbus-python-1
		dev-python/pygobject:2
		dev-python/pygobject:3
	)
"

DOC_CONTENTS="
	If you want to use rfcomm as a normal user, you need to add the user
	to the uucp group.
"

pkg_setup() {
	enewgroup plugdev
	use test && python-any-r1_pkg_setup

	if ! use udev; then
		ewarn
		ewarn "You are installing ${PN} with USE=-udev. This means various bluetooth"
		ewarn "devices and adapters from Apple, Dell, Logitech etc. will not work,"
		ewarn "and hid2hci will not be available."
		ewarn
	fi
}

src_prepare() {
	# Use static group "plugdev" if there is no ConsoleKit (or systemd logind)
	epatch "${FILESDIR}"/bluez-plugdev.patch

	# Fedora patches
	# http://www.spinics.net/lists/linux-bluetooth/msg38490.html
	epatch "${FILESDIR}"/0001-Allow-using-obexd-without-systemd-in-the-user-sessio.patch

	# http://www.spinics.net/lists/linux-bluetooth/msg40136.html
	epatch "${FILESDIR}"/0001-obex-Use-GLib-helper-function-to-manipulate-paths.patch

	# http://www.spinics.net/lists/linux-bluetooth/msg41264.html
	epatch "${FILESDIR}"/0002-autopair-Don-t-handle-the-iCade.patch

	# ???
	epatch "${FILESDIR}"/0004-agent-Assert-possible-infinite-loop.patch

	# Ubuntu workaround for bug #501120
	epatch "${FILESDIR}"/0001-work-around-Logitech-diNovo-Edge-keyboard-firmware-i.patch

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = $(cups-config --serverbin):" \
			Makefile.{in,tools} || die
	fi

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		# readline is automagic when client is enabled
		# --enable-client always needs readline, bug #504038
		ac_cv_header_readline_readline_h=$(multilib_native_usex readline)
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# deps not used for the library
			{DBUS,GLIB}_{CFLAGS,LIBS}=' '
		)
	fi

	# Missing flags: experimental (sap, nfc, ...)
	econf \
		--localstatedir=/var \
		--disable-android \
		--enable-datafiles \
		--enable-experimental \
		--enable-optimization \
		$(use_enable debug) \
		--enable-pie \
		--enable-threads \
		--enable-library \
		$(multilib_native_use_enable test) \
		--enable-tools \
		--enable-manpages \
		--enable-monitor \
		$(multilib_native_use_enable cups) \
		$(multilib_native_use_enable obex) \
		$(multilib_native_use_enable readline client) \
		$(multilib_native_use_enable systemd) \
		$(systemd_with_unitdir) \
		$(multilib_native_use_enable udev) \
		$(multilib_native_use_enable udev sixaxis)
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -f Makefile -f - libs \
			<<<'libs: $(lib_LTLIBRARIES)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install

		# Unittests are not that useful once installed
		if use test ; then
			rm -r "${ED}"/usr/$(get_libdir)/bluez/test || die
		fi
	else
		emake DESTDIR="${D}" \
			install-includeHEADERS \
			install-libLTLIBRARIES \
			install-pkgconfigDATA
	fi
}

multilib_src_install_all() {
	prune_libtool_files --modules

	keepdir /var/lib/bluetooth

	# Upstream don't want people to play with them
	# But we keep installing them due 'historical' reasons
	insinto /etc/bluetooth
	local d
	for d in input network proximity; do
		doins profiles/${d}/${d}.conf
	done
	doins src/main.conf
	doins src/bluetooth.conf

# FIXME:
# Looks like upstream installs it only for systemd, probably not needed
#	insinto /usr/share/dbus-1/system-services
#	doins src/org.bluez.service

	newinitd "${FILESDIR}"/bluetooth-init.d-r3 bluetooth
	newinitd "${FILESDIR}"/rfcomm-init.d-r2 rfcomm

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	use udev && udev_reload

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp."

	if ! has_version sys-auth/consolekit && ! has_version sys-apps/systemd; then
		elog "Since you don't have sys-auth/consolekit neither sys-apps/systemd, you will only"
		elog "be able to run bluetooth clients as root. If you want to be able to run bluetooth clients as"
		elog "a regular user, you need to add the user to the plugdev group."
	fi
}
