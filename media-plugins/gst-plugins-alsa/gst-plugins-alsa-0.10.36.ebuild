# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit gst-plugins-base gst-plugins10

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-0.9.1"
DEPEND="${RDEPEND}"

src_prepare() {
	gst-plugins10_system_link \
		gst-libs/gst/interfaces:gstreamer-interfaces \
		gst-libs/gst/audio:gstreamer-audio
}
