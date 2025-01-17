# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit autotools eutils

DESCRIPTION="Dump a remote Subversion repository"
HOMEPAGE="http://rsvndump.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="dev-vcs/subversion
	dev-libs/apr
	dev-libs/apr-util
	sys-devel/gettext"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto
		>=app-text/asciidoc-8.4 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-compile-flags.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc man) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"
}
