# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="GPS data editor and analyzer"
HOMEPAGE="http://viking.sourceforge.net/"
IUSE="doc gps nls"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PN}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

COMMONDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	net-misc/curl
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	gps? ( >=sci-geosciences/gpsd-2.96 )
"
RDEPEND="${COMMONDEPEND}
	sci-geosciences/gpsbabel
"
DEPEND="${COMMONDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	dev-util/gtk-doc-am
	app-text/rarian
	dev-libs/libxslt
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	econf \
		--disable-deprecations \
		--with-libcurl \
		--with-expat \
		--enable-google \
		--enable-terraserver \
		--enable-expedia \
		--enable-openstreetmap \
		--enable-bluemarble \
		--enable-geonames \
		--enable-geocaches \
		--enable-spotmaps \
		--disable-dem24k \
		$(use_enable gps realtime-gps-tracking) \
		$(use_enable nls)
}

src_install() {
	default
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${PN}.pdf
	fi
}
