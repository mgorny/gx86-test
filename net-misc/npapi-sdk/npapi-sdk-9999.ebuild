# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit git-r3
#endif

inherit autotools-utils

DESCRIPTION="NPAPI headers bundle"
HOMEPAGE="https://bitbucket.org/mgorny/npapi-sdk/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/pkgconfig"
#if LIVE

KEYWORDS=""
SRC_URI=
#endif
