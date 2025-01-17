# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="http://www.sleuthkit.org/sleuthkit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 IBM"
SLOT="0/10" # subslot = major soname version
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="aff ewf static-libs"

DEPEND="dev-db/sqlite:3
	ewf? ( app-forensics/libewf )
	aff? ( app-forensics/afflib )"
RDEPEND="${DEPEND}
	dev-perl/DateManip"

DOCS=( NEWS.txt README.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.0-system-sqlite.patch
	"${FILESDIR}"/${PN}-4.1.0-tools-shared-libs.patch
)

src_configure() {
	local myeconfargs=(
		$(use_with aff afflib)
		$(use_with ewf libewf)
	)
	autotools-utils_src_configure
}
