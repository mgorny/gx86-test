# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit autotools-utils

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="http://p11-glue.freedesktop.org/p11-kit.html"
SRC_URI="http://p11-glue.freedesktop.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug"

DEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
