# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

SCM=""

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="subversion"
	ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav"
	ESVN_PROJECT="libdvdnav"
	SRC_URI=""
else
	SRC_URI="http://dvdnav.mplayerhq.hu/releases/${P}.tar.xz"
fi

inherit autotools-multilib ${SCM}

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://dvdnav.mplayerhq.hu/"

LICENSE="GPL-2"
SLOT="0"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
else
	KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
fi
IUSE=""
RDEPEND=">=media-libs/libdvdread-4.2.0-r1[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r4
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig" # To get pkg.m4 for eautoreconf #414391

DOCS=( AUTHORS ChangeLog DEVELOPMENT-POLICY.txt doc/dvd_structures NEWS README TODO )

src_prepare() {
	[ "${PV#9999}" != "${PV}" ] && subversion_src_prepare
	autotools-multilib_src_prepare
}
