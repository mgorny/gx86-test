# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit xorg-2

DESCRIPTION="intel gpu userland tools"
KEYWORDS="amd64 x86"
IUSE="video_cards_nouveau"
RESTRICT="test"

DEPEND="dev-libs/glib:2
	x11-libs/cairo
	>=x11-libs/libdrm-2.4.31[video_cards_intel,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10"
RDEPEND="${DEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable video_cards_nouveau nouveau)
	)
	xorg-2_src_configure
}
