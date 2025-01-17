# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_CLIB_VER=2.1.7
inherit rox versionator

MY_PN="SystemTrayN"
MY_PV="$(replace_version_separator 3 '-')"
DESCRIPTION="SystemTrayN is an updated notification area applet for ROX-Filer"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/systemtrayn.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

APPNAME=${MY_PN}
S=${WORKDIR}
