# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils

DESCRIPTION="Implementation of the IDMEF XML draft"
HOMEPAGE="http://sourceforge.net/projects/libidmef/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

DEPEND=">=dev-libs/libxml2-2.5.10"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS ChangeLog FAQ NEWS README TODO )

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable static-libs static)
}
