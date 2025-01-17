# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit kde4-base

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.7[qt4]
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
