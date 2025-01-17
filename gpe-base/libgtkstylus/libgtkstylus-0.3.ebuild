# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

GPE_TARBALL_SUFFIX="bz2"
GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
inherit eutils gpe

DESCRIPTION="${PN} - GPE Palmtop Environment"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="${IUSE}"
GPE_DOCS=""

RDEPEND="${RDEPEND} >=gpe-base/libgpewidget-0.102"
DEPEND="${DEPEND} ${RDEPEND}"

src_install() {
	# if PREFIX= is set this will cause sandbox errors.
	make DESTDIR="${D}" install
}
