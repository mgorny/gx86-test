# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_VER="2.1.1"
ROX_LIB_VER="2.0.2"
inherit rox

MY_PN="ROX-GNOME-thumbnailer"
DESCRIPTION="Generates thumbnails for ROX-Filer using GNOME's thumbnailers"
HOMEPAGE="http://denver.sociol.unimi.it/~yuri/index-eng.html"
SRC_URI="http://denver.sociol.unimi.it/~yuri/rox/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""

APPNAME=${MY_PN}
S=${WORKDIR}
