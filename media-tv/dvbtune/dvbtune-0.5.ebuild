# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="simple tuning app for DVB cards"
HOMEPAGE="http://sourceforge.net/projects/dvbtools"
SRC_URI="mirror://sourceforge/dvbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xml"

RDEPEND="xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/linuxtv-dvb-headers"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gentoo.diff"
}

src_compile() {
	emake dvbtune

	use xml && emake xml2vdr
}

src_install() {
	dobin dvbtune

	use xml && dobin xml2vdr

	dodoc README scripts/*
}
