# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MYSPELL_DICT=(
	"nn_NO.aff"
	"nn_NO.dic"
)

MYSPELL_HYPH=(
	"hyph_nn_NO.dic"
)

MYSPELL_THES=(
	"th_nn_NO_v2.dat"
	"th_nn_NO_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Norwegian dictionaries for myspell/hunspell"
HOMEPAGE="http://spell-norwegian.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/2357/no_NO-pack2-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_unpack() {
	myspell-r2_src_unpack

	for i in *.zip; do
		unzip ${i} || die
	done
}
