# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

EGIT_REPO_URI="git://github.com/mattn/growl-for-linux"
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils git-2

DESCRIPTION="Growl Implementation For Linux"
HOMEPAGE="http://mattn.github.com/growl-for-linux/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-db/sqlite:3
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl
	net-misc/curl
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local myeconfargs=(
		--disable-static
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --modules
}
