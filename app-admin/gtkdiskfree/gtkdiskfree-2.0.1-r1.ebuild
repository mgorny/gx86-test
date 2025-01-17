# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils flag-o-matic

DESCRIPTION="Graphical tool to show free disk space"
HOMEPAGE="https://gitorious.org/gtkdiskfree"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}-master"

PATCHES=( "${FILESDIR}/${P}-desktop-file.patch" )

src_prepare() {
	sed -i \
		-e '/^CFLAGS=/s:=" -Wall -O2 :+=" :' \
		configure.in || die "sed on configure.in failed"

	# Fix underlinking, bug #463578
	append-libs -lm

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--without-gtk2
		$(use_enable nls)
	)
	autotools-utils_src_configure
}
