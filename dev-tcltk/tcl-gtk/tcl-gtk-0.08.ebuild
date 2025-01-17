# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="GTK bindings for TCL"
HOMEPAGE="http://tcl-gtk.sf.net/"
SRC_URI="mirror://sourceforge/tcl-gtk/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/tcl-8.4
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=x11-libs/vte-0.11.11:0"

src_install() {
	emake DESTDIR="${D}" install || die
}
