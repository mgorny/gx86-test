# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

DESCRIPTION="A library containing a number of classes and functions for programming GTK+ programs using C++"
HOMEPAGE="http://cxx-gtk-utils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/++/xx}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls static-libs"

RDEPEND=">=dev-libs/glib-2.26
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS="ChangeLog"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use_enable static-libs static) \
		$(use_enable nls)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/lib*.la
}
