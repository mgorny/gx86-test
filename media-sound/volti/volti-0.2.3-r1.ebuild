# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="GTK+ application for controlling audio volume from system tray/notification area"
HOMEPAGE="http://code.google.com/p/volti/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify X"

RDEPEND=">=dev-python/pygtk-2.16
	>=dev-python/pyalsaaudio-0.7-r1
	dev-python/dbus-python
	X? ( >=dev-python/python-xlib-0.15_rc1 )
	libnotify? ( x11-libs/libnotify )"
DEPEND=""

DOCS=( AUTHORS ChangeLog README )
