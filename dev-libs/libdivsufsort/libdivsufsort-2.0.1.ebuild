# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit cmake-utils multilib

DESCRIPTION="Suffix-sorting library (for BWT)"
HOMEPAGE="http://code.google.com/p/libdivsufsort/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	# will appreciate saner approach, if there is any
	sed -i -e "s:\(DESTINATION \)lib:\1$(get_libdir):" \
		*/CMakeLists.txt || die
}
