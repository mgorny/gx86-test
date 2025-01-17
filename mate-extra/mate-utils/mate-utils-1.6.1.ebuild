# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Utilities for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

IUSE="X applet ipv6 test"

RDEPEND="app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.20:2
	>=gnome-base/libgtop-2.12:2
	>=media-libs/libcanberra-0.4:0[gtk]
	sys-libs/zlib:0
	>=x11-libs/gtk+-2.20:2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/libXext:0
	x11-libs/pango:0
	applet? ( >=mate-base/mate-panel-1.6:0 )"

DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.6:0
	>=app-text/scrollkeeper-dtd-1:1.0
	>=dev-util/intltool-0.40:*
	>=mate-base/mate-common-1.6:0
	x11-proto/xextproto:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_prepare() {
	gnome2_src_prepare

	# Remove -D.*DISABLE_DEPRECATED cflagss
	# This method is kinda prone to breakage. Recheck carefully with next bump.
	# bug 339074
	LC_ALL=C find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die

	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	LC_ALL=C find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die

	if ! use test; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die
	fi

	# TODO: Check if this is needed.
	#
	# Fix intltoolize broken file, see upstream #577133
	# sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
	#	|| die "sed failed"

	# Fix up desktop files.
	LC_ALL=C find . -iname '*.desktop.in*' -exec \
		sed -e 's/Categories\(.*\)MATE/Categories\1X-MATE/' -i {} + || die
}

src_configure() {
	local myconf
	if ! use debug; then
		myconf="${myconf} --enable-debug=minimum"
	fi

	gnome2_src_configure \
		$(use_enable applet gdict-applet) \
		$(use_enable ipv6) \
		$(use_with X x) \
		--disable-maintainer-flags \
		--enable-zlib \
		${myconf}
}

DOCS="AUTHORS ChangeLog NEWS README THANKS"
