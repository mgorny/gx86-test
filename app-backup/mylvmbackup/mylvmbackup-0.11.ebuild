# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="mylvmbackup is a tool for quickly creating backups of MySQL server's data files using LVM snapshots"
HOMEPAGE="http://lenzg.net/mylvmbackup/"
SRC_URI="http://lenzg.net/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
DEPEND=">=app-text/asciidoc-8.1.0"
RDEPEND="dev-perl/Config-IniFiles
		>=sys-fs/lvm2-2.02.06
		dev-perl/DBD-mysql
		virtual/mysql
		dev-perl/TimeDate"

src_unpack() {
	unpack ${A}
	sed -i \
		-e '/^prefix/s,/usr/local,/usr,' \
		"${S}"/Makefile
}

src_install() {
	emake -j1 install DESTDIR="${D}" mandir="/usr/share/man" || die
	dodoc ChangeLog README TODO
	keepdir /var/tmp/${PN}/{backup,mnt}
	fperms 0700 /var/tmp/${PN}/
}
