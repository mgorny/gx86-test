# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KMNAME="kdepim"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="KDE Blogging Client"
HOMEPAGE="http://www.kde.org/applications/internet/blogilo"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}
	!kde-misc/bilbo
	!kde-misc/blogilo
"

PATCHES=( "${FILESDIR}/${PN}"-4.4.10-nosoprano.patch )
