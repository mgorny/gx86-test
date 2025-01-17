# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit cmake-utils

DESCRIPTION="Chewing module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8
	dev-libs/libchewing"
DEPEND="${RDEPEND}
	virtual/libintl"
