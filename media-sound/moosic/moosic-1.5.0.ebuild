# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Moosic is a music player that focuses on easy playlist management"
HOMEPAGE="http://www.nanoo.org/~daniel/moosic/"
SRC_URI="http://www.nanoo.org/~daniel/moosic/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc sparc amd64"
IUSE=""
RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}"

src_install() {
	make install INSTALL_PREFIX="${D}/usr" || die

	insinto /etc/bash_completion.d/
	newins bash_completion moosic
	dodoc ChangeLog History Moosic_Client_API.txt README Todo
}
