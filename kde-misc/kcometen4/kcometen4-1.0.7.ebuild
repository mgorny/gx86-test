# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

OPENGL_REQUIRED="always"
KDE_MINIMAL="4.10.3"
inherit kde4-base

HOMEPAGE="http://www.kde-apps.org/content/show.php?content=87586"
DESCRIPTION="OpenGL KDE4 screensaver"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/87586-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_kdebase_dep kscreensaver)
	media-libs/libart_lgpl
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"
