# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_{6,7} )

inherit python-single-r1

DESCRIPTION="A SIP connection manager for Telepathy based around the Sofia-SIP library"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.30:2
	>=net-libs/sofia-sip-1.12.11
	>=net-libs/telepathy-glib-0.17.6
	>=sys-apps/dbus-0.60
"
RDEPEND="${COMMON_DEPEND}
	!net-voip/telepathy-sofiasip
"
# telepathy-rakia was formerly known as telepathy-sofiasip
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	test? ( dev-python/twisted-core )
"
# eautoreconf requires: gtk-doc-am

src_configure() {
	econf --disable-fatal-warnings
}
