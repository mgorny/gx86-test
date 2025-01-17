# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MYSPELL_DICT=(
	"uk_UA.aff"
	"uk_UA.dic"
)

MYSPELL_HYPH=(
	"hyph_uk_UA.dic"
)

MYSPELL_THES=(
	"th_uk_UA.dat"
	"th_uk_UA.idx"
)

inherit myspell-r2

DESCRIPTION="Ukrainian dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/ukrainian-spelling-dictionary-and-thesaurus"
SRC_URI="http://extensions.libreoffice.org/extension-center/ukrainian-spelling-dictionary-and-thesaurus/releases/${PV}/dict-uk_ua-${PV}.oxt"

LICENSE="GPL-3 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
