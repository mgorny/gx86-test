# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit php-pear-r1

DESCRIPTION="Simple OO wrapper interface for the Subversion command-line client"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-XML_Parser-1.2.7"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:/usr/local:/usr:g' SVN.php || die "sed failed"
}
