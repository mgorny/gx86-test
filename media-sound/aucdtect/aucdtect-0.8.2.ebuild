# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit rpm versionator

MY_PV=$(replace_version_separator 2 '-')
MY_P="${PN}-${MY_PV}"
MY_PN="${PN/cd/CD}"

DESCRIPTION="Commandline FLAC CDDA authenticity verifier"
HOMEPAGE="http://en.true-audio.com"
SRC_URI="http://en.true-audio.com/ftp/${MY_P}.i586.rpm -> ${P}.rpm"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/usr/local/bin"

src_install() {
	exeinto /usr/bin
	doexe "${MY_PN}"
}
