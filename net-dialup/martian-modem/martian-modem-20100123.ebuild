# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit linux-mod eutils

MY_P="martian-full-${PV}"
DESCRIPTION="ltmodem alternative driver providing support for Agere Systems winmodems"
HOMEPAGE="http://packages.debian.org/sid/martian-modem-source http://phep2.technion.ac.il/linmodems/packages/ltmodem/kernel-2.6/martian"
#SRC_URI="mirror://debian/pool/non-free/m/martian-modem/${MY_P}.tar.gz"
#SRC_URI="http://phep2.technion.ac.il/linmodems/packages/ltmodem/kernel-2.6/martian/${MY_P}.tar.gz"
SRC_URI="http://linmodems.technion.ac.il/packages/ltmodem/kernel-2.6/martian/${MY_P}.tar.gz"

LICENSE="GPL-2 AgereSystems-WinModem"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

DEPEND="!net-dialup/ltmodem"
RDEPEND="${DEPEND}"

# Do NOT remove this. Stripping results in broken communication
# with core state communication channel (also see QA_* stuff below)
RESTRICT="strip"

# contains proprietary precompiled 32 bit ltmdmobj.o
QA_PREBUILT="usr/sbin/martian_modem"

S="${WORKDIR}/${P/modem/full}"
MODULE_NAMES="martian_dev(ltmodem::kmodule)"
CONFIG_CHECK="SERIAL_8250"
SERIAL_8250_ERROR="This driver requires you to compile your kernel with serial core (CONFIG_SERIAL_8250) support."

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is 2 4; then
		eerror "This driver works only with 2.6 kernels!"
		die "unsupported kernel detected"
	fi
}

src_prepare() {
	# Exclude Makefile kernel version check, we used kernel_is above.
	# TODO: More exactly, martian-modem-full-20100123 is for >kernel-2.6.20!
	epatch "${FILESDIR}/${P}-makefile.patch"

	# fix compile on amd64
	sed -i -e "/^HOST.*$/s:uname -i:uname -m:" modem/Makefile || die "sed failed"

	BUILD_TARGETS="all"
	BUILD_PARAMS="KERNEL_DIR='${KV_DIR}' SUBLEVEL='${KV_PATCH}'"
}

src_install() {
	linux-mod_src_install

	# userspace daemon and initscripts stuff
	dosbin modem/martian_modem
	newconfd "${FILESDIR}/${PN}.conf.d" ${PN}
	newinitd "${FILESDIR}/${PN}.init.d" ${PN}
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if linux_chkconfig_present SMP ; then
		elog "You have SMP (symmetric multi processor) support enabled in kernel."
		elog "You should run martian-modem with --smp enabled in MARTIAN_OPTS."
	fi
	if ! has_version net-dialup/martian-modem; then
		elog "See /etc/conf.d/${PN} for configuration options."
		elog "After you have finished the configuration, you need to run /etc/init.d/${PN} start"
		elog
	fi
	if [ "$(rc-config list default | grep martian-modem)" = "" ]; then
		elog "To run the userspace daemon automatically on every boot, just add it to a runlevel:"
		elog "rc-update add ${PN} default"
		elog
	fi
	if has_version net-dialup/wvdial; then
		elog "If using net-dialup/wvdial, you need \"Carrier Check = no\" line."
	fi
}
