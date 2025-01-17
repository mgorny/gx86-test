# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit bsdmk freebsd flag-o-matic pam

DESCRIPTION="FreeBSD's base system source for /usr/bin"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"
IUSE="ar atm audit bluetooth ipv6 kerberos netware nis ssl usb build zfs"
LICENSE="BSD zfs? ( CDDL )"

SRC_URI="mirror://gentoo/${UBIN}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${BIN}.tar.bz2
		mirror://gentoo/${INCLUDE}.tar.bz2
		zfs? ( mirror://gentoo/${CDDL}.tar.bz2 )
		build? ( mirror://gentoo/${SYS}.tar.bz2 )"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*[usb?,bluetooth?]
	ssl? ( dev-libs/openssl )
	kerberos? ( virtual/krb5 )
	ar? ( app-arch/libarchive )
	virtual/pam
	sys-libs/zlib
	>=sys-libs/ncurses-5.9
	!dev-util/csup"

DEPEND="${RDEPEND}
	sys-devel/flex
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )
	=sys-freebsd/freebsd-mk-defs-${RV}*"

RDEPEND="${RDEPEND}
	>=sys-auth/pambase-20080219.1
	sys-process/cronbase"

S="${WORKDIR}/usr.bin"

PATCHES=( "${FILESDIR}/${PN}-6.0-bsdcmp.patch"
	"${FILESDIR}/${PN}-6.0-fixmakefiles.patch"
	"${FILESDIR}/${PN}-setXid.patch"
	"${FILESDIR}/${PN}-lint-stdarg.patch"
	"${FILESDIR}/${PN}-6.0-kdump-ioctl.patch"
	"${FILESDIR}/${PN}-8.0-xinstall.patch"
	"${FILESDIR}/${PN}-8.0-bsdar.patch"
	"${FILESDIR}/${P}-compress.patch" )

# Here we remove some sources we don't need because they are already
# provided by portage's packages or similar. In order:
# - Archiving tools, provided by their own ebuilds
# - ncurses stuff
# - less stuff
# - bind utils
# - rsh stuff
# - binutils gprof
# and the rest are misc utils we already provide somewhere else.
REMOVE_SUBDIRS="bzip2 bzip2recover tar cpio
	gzip gprof
	lzmainfo xz xzdec
	tput tset tabs
	less lessecho lesskey
	dig hesinfo nslookup nsupdate host
	rsh rlogin rusers rwho ruptime
	compile_et lex vi smbutil file vacation nc ftp telnet
	c99 c89
	whois tftp"

pkg_setup() {
	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use audit || mymakeopts="${mymakeopts} WITHOUT_AUDIT= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6= WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use nis || mymakeopts="${mymakeopts} WITHOUT_NIS= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "
}

pkg_preinst() {
	# bison installs a /usr/bin/yacc symlink ...
	# we need to remove it to avoid triggering
	# collision-protect errors
	if [[ -L ${ROOT}/usr/bin/yacc ]] ; then
		rm -f "${ROOT}"/usr/bin/yacc
	fi
}

src_prepare() {
	use build || ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys"

	# Rename manpage for renamed cmp
	mv "${S}"/cmp/cmp.1 "${S}"/cmp/bsdcmp.1 || die
	# Rename manpage for renamed ar
	mv "${S}"/ar/ar.1 "${S}"/ar/freebsd-ar.1 || die
	# Fix whereis(1) manpath search.
	sed -i -e 's:"manpath -q":"manpath":' "${S}/whereis/pathnames.h"

	# Build a dynamic make
	sed -i -e '/^NO_SHARED/ s/^/#/' "${S}"/make/Makefile || die

	# Disable it here otherwise our patch wont apply
	use ar || dummy_mk ar
}

src_install() {
	freebsd_src_install

	# baselayout requires these in /bin
	dodir /bin
	for bin in sed printf; do
		mv "${D}/usr/bin/${bin}" "${D}/bin/" || die "mv ${bin} failed"
		dosym /bin/${bin} /usr/bin/${bin} || die "dosym ${bin} failed"
	done

	for pamdfile in login passwd su; do
		newpamd "${FILESDIR}/${pamdfile}.1.pamd" ${pamdfile} || die
	done

	cd "${WORKDIR}/etc"
	insinto /etc
	doins remote phones opieaccess fbtab || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/locate-updatedb-cron" locate.updatedb || die

	# tip requires /var/spool/lock/, bug #200700
	keepdir /var/spool/lock
}

pkg_postinst() {
	# We need to ensure that login.conf.db is up-to-date.
	if [[ -e "${ROOT}"etc/login.conf ]] ; then
		einfo "Updating ${ROOT}etc/login.conf.db"
		"${ROOT}"usr/bin/cap_mkdb	-f "${ROOT}"etc/login.conf "${ROOT}"etc/login.conf
		elog "Remember to run cap_mkdb /etc/login.conf after making changes to it"
	fi
}

pkg_postrm() {
	# and if we uninstall yacc but keep bison,
	# lets restore the /usr/bin/yacc symlink
	if [[ ! -e ${ROOT}/usr/bin/yacc ]] && [[ -e ${ROOT}/usr/bin/yacc.bison ]] ; then
		ln -s yacc.bison "${ROOT}"/usr/bin/yacc
	fi
}
