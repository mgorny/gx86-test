# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit autotools bash-completion-r1 eutils

DESCRIPTION="crosstool-ng is a tool to build cross-compiling toolchains"
HOMEPAGE="http://crosstool-ng.org"
MY_P=${P/ct/crosstool}
S=${WORKDIR}/${MY_P}
SRC_URI="http://ymorin.is-a-geek.org/download/crosstool-ng/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion doc"

RDEPEND="net-misc/curl
	dev-util/gperf
	dev-vcs/cvs
	dev-vcs/subversion"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-kconfig-respect-flags.patch

	# bug 450398. Fixed upstream. Remove it on the next version bump
	epatch "${FILESDIR}"/${P}-parallel-fix.patch

	#Upstream provides ${S}/bootstrap which runs autoconf -Wall --force
	#We'll use eautoconf to be portage friendly
	eautoconf -Wall --force
}

src_install() {
	emake DESTDIR="${D%/}" install
	dobashcomp ${PN}.comp
	dodoc README TODO
	use doc && mv "${D}"/usr/share/doc/crosstool-ng/"${PN}.${PVR}"/* \
		"${D}"/usr/share/doc/"${PF}"
	rm -rf "${D}"/usr/share/doc/crosstool-ng
}
