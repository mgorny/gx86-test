# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="A notification module for the portage elog-system to notify via the XMPP (Jabber) protocol"
HOMEPAGE="http://usrportage.de/"
SRC_URI="http://software.usrportage.de/portage-mod_jabber/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1
	>=dev-python/xmpppy-0.2"

src_install() {
	insinto /usr/lib/portage/pym/elog_modules
	doins mod_jabber.py

	dodoc README ChangeLog
}
