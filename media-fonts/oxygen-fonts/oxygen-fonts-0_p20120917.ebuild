# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit font

DESCRIPTION="Desktop/GUI font family for integrated use with the KDE desktop"
HOMEPAGE="https://projects.kde.org/projects/playground/artwork/oxygen-fonts"
SRC_URI="http://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_install() {
	FONTS="Bold Extra-Light Mono Regular"
	FONT_SUFFIX="ttf sfd"

	for f in ${FONTS} ; do
		FONT_S="${S}/in-progress/${f}" font_src_install
	done
}
