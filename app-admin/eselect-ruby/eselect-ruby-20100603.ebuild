# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Manages multiple Ruby versions"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.a3li.li/gentoo/distfiles/ruby.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/ruby.eselect-${PVR}" ruby.eselect || die
}
