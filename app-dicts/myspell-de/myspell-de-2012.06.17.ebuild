# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

MYSPELL_DICT=(
	"de_AT_frami.aff"
	"de_AT_frami.dic"
	"de_DE_frami.aff"
	"de_DE_frami.dic"
	"de_CH_frami.aff"
	"de_CH_frami.dic"
)

MYSPELL_HYPH=(
	"hyph_de_AT.dic"
	"hyph_de_DE.dic"
	"hyph_de_CH.dic"
)

MYSPELL_THES=(
	"th_de_AT_v2.dat"
	"th_de_AT_v2.idx"
	"th_de_DE_v2.dat"
	"th_de_DE_v2.idx"
	"th_de_CH_v2.dat"
	"th_de_CH_v2.idx"
)

inherit myspell-r2

DESCRIPTION="German dictionaries for myspell/hunspell"
HOMEPAGE="
	http://extensions.libreoffice.org/extension-center/german-de-at-frami-dictionaries
	http://extensions.libreoffice.org/extension-center/german-de-de-frami-dictionaries
	http://extensions.libreoffice.org/extension-center/german-de-ch-frami-dictionaries
"
SRC_URI="
	http://extensions.libreoffice.org/extension-center/german-de-at-frami-dictionaries/pscreleasefolder.2011-11-05.7614737245/${PV}/dict-de_at-frami_${PV//./-}.oxt
	http://extensions.libreoffice.org/extension-center/german-de-de-frami-dictionaries/releases/${PV}/dict-de_de-frami_${PV//./-}.oxt
	http://extensions.libreoffice.org/extension-center/german-de-ch-frami-dictionaries/pscreleasefolder.2011-11-05.5296069116/${PV}/dict-de_ch-frami_${PV//./-}.oxt
"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
