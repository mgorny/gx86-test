# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit mount-boot eutils toolchain-funcs

DESCRIPTION="A stand alone memory test for x86 computers"
HOMEPAGE="http://www.memtest86.com/"
SRC_URI="http://www.memtest86.com/downloads/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="serial"
S="${WORKDIR}/src"

BOOTDIR=/boot/memtest86

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch #66630

	sed -i -e 's,0x10000,0x100000,' memtest.lds || die

	if use serial ; then
		sed -i \
			-e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h \
			|| die "sed failed"
	fi

	cat - > "${T}"/39_${PN} <<EOF
#!/bin/sh
exec tail -n +3 \$0

menuentry "${PN} ${PV}" {
	linux16 ${BOOTDIR}/memtest
}
EOF

	tc-export AS CC LD
}

src_test() { :; }

src_install() {
	insinto ${BOOTDIR}
	newins memtest.bin memtest
	dosym memtest ${BOOTDIR}/memtest.bin

	exeinto /etc/grub.d
	doexe "${T}"/39_${PN}

	dodoc README README.build-process README.background
}

pkg_postinst() {
	mount-boot_pkg_postinst
	elog
	elog "memtest has been installed in ${BOOTDIR}/"
	elog "You may wish to update your bootloader configs"
	elog "by adding these lines:"
	elog " - For grub2 just run grub-mkconfig, a configuration file is installed"
	elog "   as /etc/grub/39_${PN}"
	elog " - For grub legacy: (replace '?' with correct numbers for your boot partition)"
	elog "    > title=${PN}"
	elog "    > root (hd?,?)"
	elog "    > kernel ${BOOTDIR}/memtest"
	elog " - For lilo:"
	elog "    > image  = ${BOOTDIR}/memtest"
	elog "    > label  = ${PN}"
	elog
}
