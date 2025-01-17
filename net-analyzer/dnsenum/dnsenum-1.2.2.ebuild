# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="A perl script to enumerate DNS from a server"
HOMEPAGE="http://code.google.com/p/dnsenum/"
SRC_URI="http://dnsenum.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/Net-DNS
	dev-perl/Net-IP
	dev-perl/Net-Netmask
	dev-perl/Net-Whois-IP
	dev-perl/HTML-Parser
	dev-perl/WWW-Mechanize
	dev-perl/XML-Writer"

S="${WORKDIR}"

src_prepare() {
	sed -i 's|dnsenum.pl|dnsenum|g' dnsenum.pl || die
}

src_install () {
	dodoc *.txt
	newbin ${PN}.pl ${PN}
}
