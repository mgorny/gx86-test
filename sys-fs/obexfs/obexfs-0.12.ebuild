# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

DESCRIPTION="FUSE filesystem interface for ObexFTP"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFs"
SRC_URI="mirror://sourceforge/openobex/files/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-mobilephone/obexftp-0.22
	sys-fs/fuse"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
