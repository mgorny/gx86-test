# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MY_PN="mssilk"
SDK_FILE="SILK_SDK_SRC_v1.0.8.zip" # please update silk version on bumps!

inherit autotools eutils

DESCRIPTION="SILK (skype codec) implementation for Linphone"
HOMEPAGE="http://www.linphone.org"
SRC_URI="mirror://nongnu/linphone/plugins/sources/${MY_PN}-${PV}.tar.gz
	http://developer.skype.com/silk/${SDK_FILE}"

LICENSE="GPL-2+ Clear-BSD SILK-patent-license"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="bindist"

RDEPEND=">=media-libs/mediastreamer-2.8.2:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}"

RESTRICT="mirror" # silk license forbids distribution

pkg_setup() {
	if use bindist; then
		die "This package can't be redistributable due to SILK license."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-sdk.patch"
	eautoreconf
}
