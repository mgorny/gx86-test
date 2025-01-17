# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ROX_LIB_VER="1.9.13"
inherit rox multilib

MY_PN="RETicker"
DESCRIPTION="RETicker - an RSS/RDF reader for ROX"
HOMEPAGE="http://absorb.it/tikiwiki/tiki-index.php?page=RETicker"
SRC_URI="http://absorb.it/${MY_PN}/${MY_PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

APPNAME=${MY_PN}
APPCATEGORY="Network;News"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# argh, unpack directory needs renaming
	mv "${APPNAME}_${PV}" "${APPNAME}"
}

src_install() {
	# Help dir not easily doc'ed
	# do manually
	(cd ${APPNAME}
	dodoc Help/README.txt
	mv Help Help.save
	)
	# normal install
	rox_src_install
	# move Help.save back to Help
	cd "${D}/usr/$(get_libdir)/rox/${APPNAME}"
	mv Help.save Help
}
