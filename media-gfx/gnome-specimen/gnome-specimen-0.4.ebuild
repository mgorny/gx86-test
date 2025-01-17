# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

GCONF_DEBUG=no
PYTHON_DEPEND="2:2.6"

inherit gnome2 python

DESCRIPTION="Font preview application"
HOMEPAGE="http://uwstopia.nl"
SRC_URI="http://uwstopia.nl/geek/projects/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/gconf-python
	dev-python/libgnome-python
	dev-python/pygtk
	dev-python/pygobject:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	rm -f py-compile
	ln -s $(type -P true) py-compile

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	python_convert_shebangs 2 "${D}"/usr/bin/${PN}
}

pkg_postinst() {
	python_mod_optimize specimen
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup specimen
	gnome2_pkg_postrm
}
