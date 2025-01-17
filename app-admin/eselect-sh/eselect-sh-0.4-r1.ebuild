# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Manages the /bin/sh (POSIX shell) symlink"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect-lib-bin-symlink"

S=${FILESDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins sh.eselect-${PV} sh.eselect
}
