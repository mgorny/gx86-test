# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
KDE_LINGUAS="de es nl pl"

inherit kde4-base

MY_P="mishaaq-${PN}-00370b5"

DESCRIPTION="KControl module for xf86-input-synaptics"
HOMEPAGE="http://www.kde-apps.org/content/show.php/kcm_touchpad?content=113335"
SRC_URI="http://github.com/mishaaq/kcm_touchpad/tarball/${P} -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-2.0
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS README )

src_prepare() {
	sed -e "/^install( FILES AUTHORS/d" -i CMakeLists.txt || die
	kde4-base_src_prepare
}
