# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	>=media-libs/libdvdnav-4.1.2
	>=media-libs/libdvdread-4.1.2
"
DEPEND="${RDEPEND}"
