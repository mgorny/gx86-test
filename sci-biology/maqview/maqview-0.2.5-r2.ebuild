# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="GUI for sci-biology/maq, a short read mapping assembler"
HOMEPAGE="http://maq.sourceforge.net/"
SRC_URI="mirror://sourceforge/maq/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND="
	media-libs/freeglut
	sys-libs/zlib"
RDEPEND="${DEPEND}
	sci-biology/maq"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-zlib.patch
	"${FILESDIR}"/${P}-gcc4.7.patch
	)
