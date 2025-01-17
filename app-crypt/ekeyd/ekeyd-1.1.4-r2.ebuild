# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils multilib linux-info toolchain-funcs udev

DESCRIPTION="Entropy Key userspace daemon"
HOMEPAGE="http://www.entropykey.co.uk/"
SRC_URI="http://www.entropykey.co.uk/res/download/${P}.tar.gz"

LICENSE="MIT GPL-2" # GPL-2 (only) for init script
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="usb kernel_linux munin minimal"
REQUIRED_USE="minimal? ( !munin !usb )"

EKEYD_RDEPEND="dev-lang/lua
		usb? ( virtual/libusb:0 )"
EKEYD_DEPEND="${EKEYD_RDEPEND}"
EKEYD_RDEPEND="${EKEYD_RDEPEND}
	dev-lua/luasocket
	kernel_linux? ( virtual/udev )
	usb? ( !kernel_linux? ( sys-apps/usbutils ) )
	munin? ( net-analyzer/munin )"

RDEPEND="!minimal? ( ${EKEYD_RDEPEND} )
	!app-crypt/ekey-egd-linux
	sys-apps/openrc"
DEPEND="!minimal? ( ${EKEYD_DEPEND} )"

CONFIG_CHECK="~USB_ACM"

pkg_setup() {
	if ! use minimal && use kernel_linux && ! use usb && linux_config_exists; then
		check_extra_config
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	local osname

	# Override automatic detection: upstream provides this with uname,
	# we don't like using uname.
	case ${CHOST} in
		*-linux-*)
			osname=linux;;
		*-freebsd*)
			osname=freebsd;;
		*-kfrebsd-gnu)
			osname=gnukfreebsd;;
		*-openbsd*)
			osname=openbsd;;
		*)
			die "Unsupported operating system!"
			;;
	esac

	# We don't slot LUA so we don't really need to have the variables
	# set at all.
	emake -C host \
		CC="$(tc-getCC)" \
		LUA_V= LUA_INC= \
		OSNAME=${osname} \
		OPT="${CFLAGS}" \
		BUILD_ULUSBD=$(use usb && echo yes || echo no) \
		$(use minimal && echo egd-linux)
}

src_install() {
	exeinto /usr/libexec
	newexe host/egd-linux   ekey-egd-linux
	newman host/egd-linux.8 ekey-egd-linux.8

	newconfd "${FILESDIR}"/ekey-egd-linux.conf.2 ekey-egd-linux
	newinitd "${FILESDIR}"/ekey-egd-linux.init.2 ekey-egd-linux

	dodoc doc/* AUTHORS ChangeLog THANKS

	use minimal && return
	# from here on, install everything that is not part of the minimal
	# support.

	emake -C host \
		DESTDIR="${D}" \
		MANZCMD=cat MANZEXT= \
		install-ekeyd $(use usb && echo install-ekey-ulusbd)

	# We move the daemons around to avoid polluting the available
	# commands.
	dodir /usr/libexec
	mv "${D}"/usr/sbin/ekey*d "${D}"/usr/libexec

	newinitd "${FILESDIR}"/${PN}.init.2 ${PN}

	if use usb && ! use kernel_linux; then
		newinitd "${FILESDIR}"/ekey-ulusbd.init.2 ekey-ulusbd
		newconfd "${FILESDIR}"/ekey-ulusbd.conf.2 ekey-ulusbd
	fi

	if use kernel_linux; then
		local rules=udev/fedora15/60-entropykey.rules
		use usb && rules=udev/fedora15/60-entropykey-uds.rules

		udev_newrules ${rules} 70-${PN}.rules

		exeinto "$(get_udevdir)"
		doexe udev/entropykey.sh
	fi

	if use munin; then
		exeinto /usr/libexec/munin/plugins
		doexe munin/ekeyd_stat_

		insinto /etc/munin/plugin-conf.d
		newins munin/plugin-conf.d_ekeyd ekeyd
	fi
}

pkg_postinst() {
	elog "${CATEGORY}/${PN} now install also the EGD client service ekey-egd-linux."
	elog "To use this service, you need enable EGDTCPSocket for the ekeyd service"
	elog "managing the key(s)."
	elog ""
	elog "The daemon will send more entropy to the kernel once the available pool"
	elog "falls below the value set in the kernel.random.write_wakeup_threshold"
	elog "sysctl entry."
	elog ""
	ewarn "Since version 1.1.4-r1, ekey-egd-linux will *not* set the watermark for"
	ewarn "you, instead you'll have to configure the sysctl in /etc/sysctl.conf"

	use minimal && return
	# from here on, document everything that is not part of the minimal
	# support.

	elog ""
	elog "To make use of your EntropyKey, make sure to execute ekey-rekey"
	elog "the first time, and then start the ekeyd service."
	elog ""
	elog "By default ekeyd will feed the entropy directly to the kernel's pool;"
	elog "if your system has jumps in load average, you might prefer using the"
	elog "EGD compatibility mode, by enabling EGDTCPSocket for ekeyd and then"
	elog "starting the ekey-egd-linux service."
	elog ""
	elog "The same applies if you intend to provide entropy for multiple hosts"
	elog "over the network. If you want to have the ekey-egd-linux service on"
	elog "other hosts, you can enable the 'minimal' USE flag."
	elog ""
	elog "The service supports multiplexing if you wish to use multiple"
	elog "keys, just symlink /etc/init.d/ekeyd → /etc/init.d/ekeyd.identifier"
	elog "and it'll be looking for /etc/entropykey/identifier.conf"
	elog ""

	if use usb; then
		if use kernel_linux; then
			elog "You're going to use the userland USB daemon, the udev rules"
			elog "will be used accordingly. If you want to use the CDC driver"
			elog "please disable the usb USE flag."
		else
			elog "You're going to use the userland USB daemon, since your OS"
			elog "does not support udev, you should start the ekey-ulusbd"
			elog "service before ekeyd."
		fi

		ewarn "The userland USB daemon has multiple known issues. If you can,"
		ewarn "please consider disabling the 'usb' USE flag and instead use the"
		ewarn "CDC-ACM access method."
	else
		if use kernel_linux; then
			elog "Some versions of Linux have a faulty CDC ACM driver that stops"
			elog "EntropyKey from working properly; please check the compatibility"
			elog "table at http://www.entropykey.co.uk/download/"
		else
			elog "Make sure your operating system supports the CDC ACM driver"
			elog "or otherwise you won't be able to use the EntropyKey."
		fi
		elog ""
		elog "If you're unsure about the working state of the CDC ACM driver"
		elog "enable the usb USE flag and use the userland USB daemon"
	fi
}
