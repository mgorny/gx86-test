# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit pam eutils user

DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"

S=${WORKDIR}

pkg_setup() {
	enewgroup mail 12
	enewuser mail 8 -1 /var/spool/mail mail
	enewuser postmaster 14 -1 /var/spool/mail
}

src_install() {
	dodir /etc/mail
	insinto /etc/mail
	doins "${FILESDIR}"/aliases || die
	insinto /etc
	doins "${FILESDIR}"/mailcap || die

	keepdir /var/spool/mail
	fowners root:mail /var/spool/mail
	fperms 03775 /var/spool/mail
	dosym /var/spool/mail /var/mail

	newpamd "${FILESDIR}"/common-pamd-include pop
	newpamd "${FILESDIR}"/common-pamd-include imap
	if use pam ; then
		local p
		for p in pop3 pop3s pops ; do
			dosym pop /etc/pam.d/${p} || die
		done
		for p in imap4 imap4s imaps ; do
			dosym imap /etc/pam.d/${p} || die
		done
	fi
}

get_permissions_oct() {
	if [[ ${USERLAND} = GNU ]] ; then
		stat -c%a "${ROOT}$1"
	elif [[ ${USERLAND} = BSD ]] ; then
		stat -f%p "${ROOT}$1" | cut -c 3-
	fi
}

pkg_postinst() {
	if [[ "$(get_permissions_oct /var/spool/mail)" != "3775" ]] ; then
		echo
		ewarn "Your ${ROOT}var/spool/mail/ directory permissions differ from"
		ewarn "  those which mailbase wants to set it to (03775)."
		ewarn "  If you did not change them on purpose, consider running:"
		ewarn
		ewarn "    chown root:mail ${ROOT}var/spool/mail/"
		ewarn "    chmod 03775 ${ROOT}var/spool/mail/"
		echo
	fi
}
