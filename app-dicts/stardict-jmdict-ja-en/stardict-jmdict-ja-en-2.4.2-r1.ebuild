# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

FROM_LANG="Japanese"
TO_LANG="English"
DICT_PREFIX="jmdict-"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_ja.php"
SRC_URI="mirror://sourceforge/stardict/${P}.tar.bz2"

LICENSE="GDLS"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""
