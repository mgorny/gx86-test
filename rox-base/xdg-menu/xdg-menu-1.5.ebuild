# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_LIB_VER=2.0.0

inherit rox

MY_PN=XDG-Menu

DESCRIPTION="XDG-Menu is a ROX Menu Application that is XDG Compliant"
HOMEPAGE="http://xdg-menu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-python/pyxdg-0.14
	>=dev-python/dbus-python-0.80.2
	gnome-base/gnome-menus"
DEPEND="sys-devel/gettext"

APPNAME=${MY_PN}

S=${WORKDIR}
