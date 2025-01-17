# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="CPU, memory, swap, network stats for G15 Keyboard"
HOMEPAGE="http://g15daemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-misc/g15daemon-1.9.0
	dev-libs/libg15
	dev-libs/libg15render
	sys-libs/zlib
	gnome-base/libgtop"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	export CPPFLAGS=$CFLAGS
	econf || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	rm "$D"/usr/share/doc/${P}/{COPYING,NEWS}

	newconfd "${FILESDIR}/${P}.confd" ${PN}
	newinitd "${FILESDIR}/${P}.initd" ${PN}

	prepalldocs
}

pkg_postinst() {
	elog "Remember to set the interface you want monitored in"
	elog "/etc/conf.d/g15stats"
}
