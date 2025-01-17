# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_CLIB_VER="2.1.8"
inherit rox

MY_PN="Tail"
DESCRIPTION="Tail is a ROX Application to monitor file changes a la \`tail -f'"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/tail.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

APPNAME=${MY_PN}
S=${WORKDIR}
