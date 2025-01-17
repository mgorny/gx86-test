# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit autotools

DESCRIPTION="Daemon to disable trackpads while typing"
HOMEPAGE="https://github.com/BlueDragonX/dispad"
SRC_URI="https://github.com/BlueDragonX/dispad/tarball/v${PV/_/-} -> ${P}.tar.gz"

S="${WORKDIR}/BlueDragonX-dispad-6e96d0d"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXi
	dev-libs/confuse"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf -i
}
