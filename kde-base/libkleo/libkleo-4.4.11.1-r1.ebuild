# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE library for encryption handling"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/gpgme
	$(add_kdebase_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

PATCHES=( "${FILESDIR}/${P}-gcc47.patch" )

KMSAVELIBS="true"
KMEXTRACTONLY="kleopatra/"
