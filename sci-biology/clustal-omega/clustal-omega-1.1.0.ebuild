# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Scalable multiple alignment of protein sequences"
HOMEPAGE="http://www.clustal.org/omega/"
SRC_URI="http://www.clustal.org/omega/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/argtable"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	sed \
		-e "s:-O3::g" \
		-i configure.ac || die
	autotools-utils_src_prepare
}
