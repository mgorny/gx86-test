# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils toolchain-funcs user

DESCRIPTION="System & Network Integrated Polling Software"
HOMEPAGE="http://www.netplex-tech.com/snips/"
SRC_URI="http://www.netplex-tech.com/software/downloads/${PN}/${P}.tar.gz"

LICENSE="SNIPS BSD HPND GPL-1+ RSA free-noncomm"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/perl
	 virtual/mailx
	 net-analyzer/rrdtool
	 >=net-misc/iputils-20071127-r2
	 sys-libs/gdbm
	 sys-libs/ncurses"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Gentoo-specific non-interactive configure override
	cp "${FILESDIR}/${PF}-precache-config" "${S}/Config.cache" \
		|| die "Unable to precache configure script answers"
	echo "CFLAGS=\"${CFLAGS} -fPIC\"" >> "${S}/Config.cache"
	echo "CC=\"$(tc-getCC)\"" >> "${S}/Config.cache"
	echo "SRCDIR=\"${S}\"" >> "${S}/Config.cache"
	epatch "${FILESDIR}/${P}-non-interactive.patch"
	# Applied to upstream CVS
	epatch "${FILESDIR}/${P}-install-missing.patch"
	epatch "${FILESDIR}/${P}-implicit-declarations.patch"
	epatch "${FILESDIR}/${P}-conflicting-types.patch"
	epatch "${FILESDIR}/${P}-code-ordering.patch"
	epatch "${FILESDIR}/${P}-destdir-awareness.patch"
	epatch "${FILESDIR}/${P}-link-correct-snmp-lib.patch"
}

src_compile() {
	# Looks horrid due to missing linebreaks, suppress output
	ebegin "Running configure script (with precached settings)"
		./Configure &> /dev/null || die "Unable to configure"
	eend $?
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_preinst() {
	enewgroup snips
	enewuser snips -1 -1 /usr/snips snips
}

pkg_postinst() {
	ebegin "Fixing permissions"
	chown -R snips:snips "${ROOT}"usr/snips
	for x in data logs msgs rrddata run web device-help etc; do
		chmod -R g+w "${ROOT}usr/snips/${x}" \
			|| die "Unable to chmod ${x}"
	done
	chown root:snips "${ROOT}usr/snips/bin/multiping" || die "chown root failed"
	chown root:snips "${ROOT}usr/snips/bin/etherload" || die "chown root failed"
	chown root:snips "${ROOT}usr/snips/bin/trapmon" || die "chown root failed"
	chmod u+s "${ROOT}usr/snips/bin/multiping" || die "SetUID root failed"
	chmod u+s "${ROOT}usr/snips/bin/etherload" || die "SetUID root failed"
	chmod u+s "${ROOT}usr/snips/bin/trapmon" || die "SetUID root failed"
	eend $?
}
