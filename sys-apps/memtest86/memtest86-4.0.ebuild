# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit mount-boot eutils toolchain-funcs

DESCRIPTION="A stand alone memory test for x86 computers"
HOMEPAGE="http://www.memtest86.com/"
SRC_URI="http://www.memtest86.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="serial"
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-4.0-build.patch #66630

	if use serial ; then
		sed -i \
			-e '/^#define SERIAL_CONSOLE_DEFAULT/s:0:1:' \
			config.h \
			|| die "sed failed"
	fi

	tc-export AS CC LD
}

src_install() {
	insinto /boot/memtest86
	doins memtest.bin || die "doins failed"
	dodoc README README.build-process
}

pkg_postinst() {
	mount-boot_pkg_postinst
	einfo
	einfo "memtest.bin has been installed in /boot/memtest86/"
	einfo "You may wish to update your bootloader configs"
	einfo "by adding these lines:"
	einfo " - For grub: (replace '?' with correct numbers for your boot partition)"
	einfo "    > title=Memtest86"
	einfo "    > root (hd?,?)"
	einfo "    > kernel /boot/memtest86/memtest.bin"
	einfo " - For lilo:"
	einfo "    > image  = /boot/memtest86/memtest.bin"
	einfo "    > label  = Memtest86"
	einfo
}
