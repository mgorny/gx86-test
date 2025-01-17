# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Wrapper for java-config"
HOMEPAGE="http://www.gentoo.org/proj/en/java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="!<dev-java/java-config-1.3"
RDEPEND="app-portage/portage-utils"

src_install() {
	dobin src/shell/* || die
	dodoc AUTHORS || die
}
