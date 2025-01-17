# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a gesture-recognition application for X11"
HOMEPAGE="http://sourceforge.net/apps/trac/easystroke/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:3.0
	dev-libs/boost
	dev-libs/dbus-glib
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cellrendertextish.patch
	epatch "${FILESDIR}"/${P}-desktop.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch

	tc-export CC CXX PKG_CONFIG

	strip-linguas -i po/

	local es_lingua lang
	for es_lingua in $( printf "%s\n" po/*.po ); do
		lang=${es_lingua/po\/}
		has ${lang/.po/} ${LINGUAS} || rm ${es_lingua}
	done
}

src_compile() {
	emake \
		AOFLAGS='' \
		LDFLAGS="${LDFLAGS}" \
		PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
