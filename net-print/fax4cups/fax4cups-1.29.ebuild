# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="Fax backend for CUPS"

HOMEPAGE="http://vigna.dsi.unimi.it/fax4CUPS/"
SRC_URI="http://vigna.dsi.unimi.it/fax4CUPS/fax4CUPS-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+hylafax mgetty-fax efax capisuite-fax"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}
	|| (
	  hylafax? ( net-misc/hylafaxplus )
	  efax? ( net-misc/efax )
	  mgetty-fax? ( net-dialup/mgetty )
	  capisuite-fax? ( net-dialup/capisuite )
	)
	app-admin/sudo"

S=${WORKDIR}/fax4CUPS-${PV}

REQUIRED_USE="|| ( hylafax mgetty-fax efax capisuite-fax )"

src_install() {
	doman fax4CUPS.1

	exeinto $(cups-config --serverbin)/backend
	insinto /usr/share/cups/model

	for i in hylafax efax mgetty-fax capisuite-fax; do
		if use $i
		then
			# Backend
			doexe $i
			# PPD
			doins $i.ppd
		fi
	done
}

pkg_postinst() {
	elog "Please execute '/etc/init.d/cups restart'"
	elog "to get the *.ppd files working properly"
}
