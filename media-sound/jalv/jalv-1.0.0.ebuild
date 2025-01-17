# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit waf-utils

DESCRIPTION="Simple but fully featured LV2 host for Jack"
HOMEPAGE="http://drobilla.net/software/jalv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk gtkmm qt4"

RDEPEND="media-libs/lv2
	>=media-libs/lilv-0.14.0
	>=dev-libs/serd-0.4.5
	>=media-libs/suil-0.6.0
	>=media-libs/sratom-0.2.0
	>=media-sound/jack-audio-connection-kit-0.120.0
	gtk? ( >=x11-libs/gtk+-2.18.0:2 )
	gtkmm? ( >=dev-cpp/gtkmm-2.20.0:2.4 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "AUTHORS" "NEWS" "README" )

src_configure() {
	# otherwise automagic
	use gtk || sed -i -e 's/gtk+-2.0/DiSaBlEd/' wscript
	use gtkmm || sed -i -e 's/gtkmm-2.4/DiSaBlEd/' wscript
	use qt4 || sed -i -e 's/QtGui/DiSaBlEd/' wscript
	waf-utils_src_configure \
		"--docdir=/usr/share/doc/${PF}"
}
