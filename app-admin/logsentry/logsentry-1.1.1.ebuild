# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit toolchain-funcs

DESCRIPTION="automatically monitor system logs and mail security violations on a periodic basis"
# Seems that the project has been discontinued by CISCO?
HOMEPAGE="http://sourceforge.net/projects/sentrytools/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc s390 sh sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND="virtual/mailx"

S="${WORKDIR}"/logcheck-${PV}

src_compile() {
	einfo "compile and install mixed in the package makefile"
}

src_install() {
	dodir /usr/bin /etc/logcheck/tmp
	cp systems/linux/logcheck.sh{,.orig}
	sed -i \
		-e 's:/usr/local/bin:/usr/bin:' \
		-e 's:/usr/local/etc:/etc/logcheck:' \
		systems/linux/logcheck.sh || \
			die "sed logcheck.sh failed"
	sed -i \
		-e "s:/usr/local/bin:${D}/usr/bin:" \
		-e "s:/usr/local/etc:${D}/etc/logcheck:" \
		-e "s:\$(CC):& \$(LDFLAGS):" \
		Makefile || die "sed Makefile failed"
	make CC="$(tc-getCC)" CFLAGS="${CFLAGS}" linux || die

	dodoc README* CHANGES CREDITS
	dodoc systems/linux/README.*

	cat << EOF > "${S}"/logsentry.cron
#!/bin/sh
#
# Uncomment the following if you want
# logsentry (logcheck) to run hourly
#
# this is part of the logsentry package
#
#

#/bin/sh /etc/logcheck/logcheck.sh
EOF

	exeinto /etc/cron.hourly
	doexe logsentry.cron
}

pkg_postinst() {
	elog
	elog "Uncomment the logcheck line in /etc/cron.hourly/logsentry.cron,"
	elog "or add directly to root's crontab"
	elog
}
