# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="standard informational utilities and process-handling tools"
# http://packages.debian.org/sid/procps
HOMEPAGE="http://procps.sourceforge.net/ http://gitorious.org/procps"
# SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.xz"
FEDORA_HASH="0980646fa25e0be58f7afb6b98f79d74"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}-ng/${PN}-ng-${PV}.tar.xz/${FEDORA_HASH}/${PN}-ng-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="+ncurses nls selinux static-libs systemd test unicode"

RDEPEND="!<sys-apps/sysvinit-2.88-r6
	ncurses? ( >=sys-libs/ncurses-5.7-r7[unicode?] )
	selinux? ( sys-libs/libselinux )
	systemd? ( >=sys-apps/systemd-209 )"
DEPEND="${RDEPEND}
	ncurses? ( virtual/pkgconfig )
	systemd? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )"

S=${WORKDIR}/${PN}-ng-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.3.8-kill-neg-pid.patch \
		"${FILESDIR}"/${P}-sysctl-load-config-files.patch
	sed -i -e 's:systemd-login:systemd:' configure || die #501306
}

src_configure() {
	econf \
		--exec-prefix="${EPREFIX}" \
		--docdir='$(datarootdir)'/doc/${PF} \
		$(use_with ncurses) \
		$(use_enable nls) \
		$(use_enable selinux libselinux) \
		$(use_enable static-libs static) \
		$(use_with systemd) \
		$(use_enable unicode watch8bit)
}

src_install() {
	default
#	dodoc sysctl.conf

	mv "${ED}"/usr/bin/pidof "${ED}"/bin/ || die

	# The configure script is completely whacked in the head
	mv "${ED}"/lib* "${ED}"/usr/ || die
	gen_usr_ldscript -a procps
	prune_libtool_files
}
