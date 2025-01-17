# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="${PN/pp/++}"

inherit gnome2

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"

RDEPEND=">=dev-libs/libxml2-2.7.3
	>=dev-cpp/glibmm-2.32"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README*"
	G2CONF="${G2CONF} $(use_enable doc documentation)"

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	rm -fr "${ED}"usr/share/doc/libxml++*
	use doc && dohtml docs/reference/html/*
}
