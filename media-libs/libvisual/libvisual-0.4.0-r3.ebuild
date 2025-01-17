# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
AUTOTOOLS_AUTORECONF=1

inherit autotools-multilib

DESCRIPTION="Libvisual is an abstraction library that comes between applications and audio visualisation plugins"
HOMEPAGE="http://libvisual.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.4"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug nls static-libs threads"

RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r9
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-better-altivec-detection.patch
	"${FILESDIR}"/${P}-inlinedefineconflict.patch
	"${FILESDIR}"/${P}-conditions.patch
	"${FILESDIR}"/${P}-detect_amd64.patch
	"${FILESDIR}"/${P}-cond.patch
	)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libvisual-0.4/libvisual/lvconfig.h
)

src_prepare() {
	autotools-multilib_src_prepare
	# autogenerated, causes problems for out of tree builds
	rm -f libvisual/lvconfig.h || die
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable nls)
		$(use_enable threads)
		$(use_enable debug)
	)
	autotools-multilib_src_configure
}
