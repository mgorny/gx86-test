# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_LIB_VER=1.9.12
inherit rox

DESCRIPTION="Picky - an image viewer/slideshow app for the ROX Desktop"
MY_PN="Picky"
HOMEPAGE="http://www.rdsarts.com/code/picky/"
SRC_URI="http://www.rdsarts.com/code/picky/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

APPNAME=${MY_PN}
APPCATEGORY="Graphics;Viewer"

src_unpack() {
	mkdir -p "${S}"/${APPNAME}
	cd "${S}"/${APPNAME}
	unpack ${A}
}
