# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Bash scripts to install tripwire and generate tripwire policy files"
HOMEPAGE="https://sourceforge.net/projects/mktwpol"
SRC_URI="mirror://sourceforge/mktwpol/${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="app-admin/tripwire"

src_prepare() {
	sed -i -e 's|/usr/local|/usr|' Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog
	elog "Installation and setup of tripwire ..."
	elog " - Run: \`twsetup.sh\`"
	elog
	elog "Maintenance of tripwire as packages are added and/or deleted ..."
	elog " - Run: \`mktwpol.sh -u\` to update tripwire policy and database"
	elog
}
