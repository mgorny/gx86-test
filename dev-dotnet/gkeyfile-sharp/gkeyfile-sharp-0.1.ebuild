# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit autotools mono

DESCRIPTION="C# binding for gkeyfile"
HOMEPAGE="http://launchpad.net/gkeyfile-sharp http://github.com/mono/gkeyfile-sharp"
SRC_URI="http://github.com/mono/${PN}/tarball/GKEYFILE_SHARP_0_1 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-dotnet/glib-sharp-2.12.9
	>=dev-dotnet/gtk-sharp-gapi-1.9"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS
}
