# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit gnustep-2

MY_PN=${PN/p/P}

S=${WORKDIR}/${MY_PN}

DESCRIPTION="A set of Objective-C classes that model a mail system"
HOMEPAGE="http://www.collaboration-world.com/pantomime/"
SRC_URI="http://www.collaboration-world.com/pantomime.data/releases/Stable/${MY_PN}-${PV/_/}.tar.gz"

LICENSE="LGPL-2.1 Elm"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
SLOT="0"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_install() {
	gnustep-base_src_install

	dodoc "${S}"/Documentation/*
	docinto rfc
	dodoc "${S}"/Documentation/RFC/*
}
