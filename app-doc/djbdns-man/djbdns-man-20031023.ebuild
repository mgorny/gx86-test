# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

S=${WORKDIR}/${PN}
DESCRIPTION="Man pages for djbdns"
SRC_URI="http://smarden.org/pape/djb/manpages/djbdns-1.05-man-${PV}.tar.gz"
HOMEPAGE="http://smarden.org/pape/djb/manpages/"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_install() {
	dodoc README

	doman *.8 *.5 *.1
}
