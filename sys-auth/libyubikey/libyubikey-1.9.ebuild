# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils

DESCRIPTION="Yubico C low-level library"
HOMEPAGE="https://github.com/Yubico/yubico-c"
SRC_URI="http://yubico-c.googlecode.com/files/${P}.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="BSD-2"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	emake check
}

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_install() {
	default
	prune_libtool_files
}
