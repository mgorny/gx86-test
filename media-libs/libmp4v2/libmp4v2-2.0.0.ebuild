# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit libtool

MY_P=${P/lib}

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="http://code.google.com/p/mp4v2/"
SRC_URI="http://mp4v2.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs test utils"

RDEPEND=""
DEPEND="sys-apps/sed
	utils? ( sys-apps/help2man )
	test? ( dev-util/dejagnu )"

DOCS="doc/*.txt README"

S=${WORKDIR}/${MY_P}

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-gch \
		$(use_enable utils util) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
