# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
#PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils perl-module toolchain-funcs

DESCRIPTION="Port Scanning Attack Detection daemon"
SRC_URI="http://www.cipherdyne.org/psad/download/${P}.tar.bz2"
HOMEPAGE="http://www.cipherdyne.org/psad"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ppc ~sparc x86"

DEPEND="virtual/perl-ExtUtils-MakeMaker"
RDEPEND="
	dev-perl/Bit-Vector
	dev-perl/Date-Calc
	dev-perl/NetAddr-IP
	dev-perl/Unix-Syslog
	net-firewall/iptables
	net-misc/whois
	virtual/logger
	virtual/mailx
	virtual/perl-Storable
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2-var-run.patch

	sed -i \
		-e 's|/usr/bin/gcc|$(CC)|g' \
		-e 's|-O|$(CFLAGS) $(LDFLAGS)|g' \
		Makefile || die
	# Fix up default paths
	sed -i \
		-e "s:/sbin/syslog-ng:/usr/sbin/syslog-ng:g" \
		-e "s:/sbin/syslogd:/usr/sbin/syslogd:g" \
		-e "s:/usr/bin/whois_psad:/usr/bin/whois:g" \
		psad.conf || die
}

src_configure() {
	default

	local deps_subdir
	for deps_subdir in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${deps_subdir} || die
		SRC_PREP="no" perl-module_src_configure
	done
}

src_compile() {
	tc-export CC
	default

	local deps_subdir
	for deps_subdir in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${deps_subdir} || die
		perl-module_src_compile
	done
}

src_install() {
	newbin pscan psad-pscan

	insinto /usr
	dosbin kmsgsd psad psadwatchd
	newsbin fwcheck_psad.pl fwcheck_psad

	insinto /etc/psad
	doins \
		*.conf auto_dl icmp{,6}_types ip_options psad_* pf.os posf \
		protocols signatures

	newinitd init-scripts/psad-init.gentoo psad

	doman *.8

	dodoc BENCHMARK CREDITS Change* FW_EXAMPLE_RULES README SCAN_LOG

	keepdir /var/lib/${PN} /var/log/${PN}

	insinto /etc/psad/snort_rules
	doins deps/snort_rules/*

	local deps_subdir
	for deps_subdir in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${deps_subdir} || die
		perl-module_src_install
	done
}

pkg_postinst() {
	if [ ! -p "${ROOT}"/var/lib/psad/psadfifo ]
	then
		ebegin "Creating syslog FIFO for PSAD"
		mknod -m 600 "${ROOT}"/var/lib/psad/psadfifo p
		eend $?
	fi
}
