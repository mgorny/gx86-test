# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="A morse daemon for the parallel or serial port"
HOMEPAGE="http://cwdaemon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=media-radio/unixcw-3.1.1"
DEPEND="$RDEPEND
	virtual/pkgconfig"
