# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_LIB_VER="2.0.4-r1"
inherit rox-0install

MY_PN="Thumbs"

DESCRIPTION="A very simple Rox thumbnail image manager"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/thumbs.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 ppc sparc x86"

APPNAME=${MY_PN}
S=${WORKDIR}
LOCAL_FEED_SRC="${FILESDIR}/Thumbs-${PV}.xml"
