# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit autotools eutils #git-2

# If github is desired, the following may be used.
#EGIT_REPO_URI="git://github.com/signal11/hidapi.git"
#EGIT_BRANCH="master"
#EGIT_COMMIT="119135b8ce0e8db668ec171723d6e56d4394166a"

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="http://www.signal11.us/oss/hidapi/"
SRC_URI="http://public.callutheran.edu/~abarker/${P}.tar.xz"
# When 0.8.0 is officially available the following link should be used.
#SRC_URI="mirror://github/signal11/${PN}/${P}.zip"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc static-libs X"

# S is only needed for the pre_package
S=${WORKDIR}/${PN}
RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	X? ( x11-libs/fox:1.6 )"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable X testgui)
}

src_compile() {
	emake

	if use doc; then
		doxygen doxygen/Doxyfile || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		dohtml -r html/*
	fi

	prune_libtool_files
}
