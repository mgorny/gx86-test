# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PLOCALES="ca cs da de el en es es_MX fi fr he hu id it ja nl pl pt pt_BR ro ru
sk sv tr uk zh_CN"
PLOCALE_BACKUP="en"
inherit fdo-mime gnome2-utils qt4-r2 l10n readme.gentoo

DESCRIPTION="A fullscreen and distraction-free word processor"
HOMEPAGE="http://gottcode.org/focuswriter/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="app-text/enchant
	dev-libs/libzip
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog CREDITS README )
DOC_CONTENTS="Focuswriter has optional sound support if media-libs/sdl-mixer is
installed with wav useflag enabled."

src_prepare() {
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr"
}

src_install() {
	readme.gentoo_create_doc
	qt4-r2_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

rm_loc() {
	sed -e "s|translations/${PN}_${1}.ts||"	-i ${PN}.pro || die 'sed failed'
	rm translations/${PN}_${1}.{ts,qm} || die "removing ${1} locale failed"
}
