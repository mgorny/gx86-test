# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Program that can get information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
DEPEND=">=dev-libs/libx86-1.1"
RDEPEND="$DEPEND"

src_compile() {
	econf --mandir=/usr/share/man || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	# as per bug #283322
	dobin parse-edid || die "failed to install parse-edid binary"
	rm "${D}"/usr/sbin/parse-edid
	dodoc AUTHORS ChangeLog NEWS README
}
