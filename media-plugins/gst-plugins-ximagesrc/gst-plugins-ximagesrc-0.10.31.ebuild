# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit gst-plugins-good

KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libSM
"
DEPEND="${RDEPEND}
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/xextproto
	x11-proto/xproto
"

# xshm is a compile time option of ximage
GST_PLUGINS_BUILD="x xshm"
GST_PLUGINS_BUILD_DIR="ximage"
