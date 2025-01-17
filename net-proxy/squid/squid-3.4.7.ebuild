# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit autotools eutils linux-info pam toolchain-funcs user versionator

DESCRIPTION="A full-featured web proxy cache"
HOMEPAGE="http://www.squid-cache.org/"
SRC_URI="ftp://ftp.squid-cache.org/pub/archive/3.4/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="caps ipv6 pam ldap samba sasl kerberos nis radius ssl snmp selinux logrotate test \
	ecap esi icap-client ssl-crtd \
	mysql postgres sqlite \
	qos tproxy \
	+htcp +wccp +wccpv2 \
	pf-transparent ipf-transparent kqueue \
	elibc_uclibc kernel_linux"

COMMON_DEPEND="caps? ( >=sys-libs/libcap-2.16 )
	pam? ( virtual/pam )
	ldap? ( net-nds/openldap )
	kerberos? ( virtual/krb5 )
	qos? ( net-libs/libnetfilter_conntrack )
	ssl? ( dev-libs/openssl dev-libs/nettle )
	sasl? ( dev-libs/cyrus-sasl )
	ecap? ( net-libs/libecap:0.2 )
	esi? ( dev-libs/expat dev-libs/libxml2 )
	selinux? ( sec-policy/selinux-squid )
	!x86-fbsd? ( logrotate? ( app-admin/logrotate ) )
	>=sys-libs/db-4
	sys-devel/libtool
	dev-lang/perl
	sys-devel/libtool"
DEPEND="${COMMON_DEPEND}
	ecap? ( virtual/pkgconfig )
	sys-apps/ed
	test? ( dev-util/cppunit )"
RDEPEND="${COMMON_DEPEND}
	samba? ( net-fs/samba )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	sqlite? ( dev-perl/DBD-SQLite )
	!<=sci-biology/meme-4.8.1-r1"

REQUIRED_USE="tproxy? ( caps )
			qos? ( caps )"

pkg_pretend() {
	if use tproxy; then
		local CONFIG_CHECK="~NF_CONNTRACK ~NETFILTER_TPROXY ~NETFILTER_XT_MATCH_SOCKET ~NETFILTER_XT_TARGET_TPROXY"
		linux-info_pkg_setup
	fi
}

pkg_setup() {
	enewgroup squid 31
	enewuser squid 31 -1 /var/cache/squid squid
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.3.4-gentoo.patch"
	sed -i -e 's:/usr/local/squid/etc:/etc/squid:' \
		INSTALL QUICKSTART \
		helpers/basic_auth/MSNT/README.html \
		helpers/basic_auth/MSNT/confload.cc \
		helpers/basic_auth/MSNT/msntauth.conf.default \
		scripts/fileno-to-pathname.pl \
		scripts/check_cache.pl \
		tools/cachemgr.cgi.8 \
		tools/purge/conffile.hh \
		tools/purge/README  || die
	sed -i -e 's:/usr/local/squid/sbin:/usr/sbin:' \
		INSTALL QUICKSTART || die
	sed -i -e 's:/usr/local/squid/var/cache:/var/cache/squid:' \
		QUICKSTART || die
	sed -i -e 's:/usr/local/squid/var/logs:/var/log/squid:' \
		QUICKSTART \
		src/log/access_log.cc || die
	sed -i -e 's:/usr/local/squid/logs:/var/log/squid:' \
		src/log/access_log.cc || die
	sed -i -e 's:/usr/local/squid/bin:/usr/bin:' \
		helpers/basic_auth/MSNT/README.html || die
	sed -i -e 's:/usr/local/squid/libexec:/usr/libexec/squid:' \
		helpers/external_acl/unix_group/ext_unix_group_acl.8 \
		helpers/external_acl/session/ext_session_acl.8 \
		src/ssl/ssl_crtd.8 || die
	sed -i -e 's:/usr/local/squid/cache:/var/cache/squid:' \
		scripts/check_cache.pl || die
	sed -i -e 's:/usr/local/squid/ssl_cert:/etc/ssl/squid:' \
		src/ssl/ssl_crtd.8 || die
	sed -i -e 's:/usr/local/squid/var/lib/ssl_db:/var/lib/squid/ssl_db:' \
		src/ssl/ssl_crtd.8 || die
	sed -i -e 's:/var/lib/ssl_db:/var/lib/squid/ssl_db:' \
		src/ssl/ssl_crtd.8 || die
	# /var/run/squid to /run/squid
	sed -i -e 's:$(localstatedir)::' \
		src/ipc/Makefile.am

	epatch_user

	# Bug #419685 - eautoreconf in src_prepare() fails in libltdl/
	#               aclocal-1.11: `configure.ac' or `configure.in' is required
	MAKEOPTS="${MAKEOPTS} -j1" eautoreconf
}

src_configure() {
	local basic_modules="MSNT,MSNT-multi-domain,NCSA,POP3,getpwnam"
	use samba && basic_modules+=",SMB"
	use ldap && basic_modules+=",LDAP"
	use pam && basic_modules+=",PAM"
	use sasl && basic_modules+=",SASL"
	use nis && ! use elibc_uclibc && basic_modules+=",NIS"
	use radius && basic_modules+=",RADIUS"
	if use mysql || use postgres || use sqlite ; then
		basic_modules+=",DB"
	fi

	local digest_modules="file"
	use ldap && digest_modules+=",LDAP,eDirectory"

	local negotiate_modules myconf
	if use kerberos ; then
		negotiate_modules="kerberos,wrapper"
		myconf="--with-krb5-config=yes"
	else
		negotiate_modules="none"
		myconf="--with-krb5-config=no"
	fi

	local ntlm_modules="none"
	use samba && ntlm_modules="smb_lm"

	local ext_helpers="file_userip,session,unix_group"
	use samba && ext_helpers+=",wbinfo_group"
	use ldap && ext_helpers+=",LDAP_group,eDirectory_userip"
	use ldap && use kerberos && ext_helpers+=",kerberos_ldap_group"

	# uclibc does not have aio support - needed for coss (#61175)
	local storeio_modules="aufs,diskd,rock,ufs"

	local transparent
	if use kernel_linux ; then
		transparent+=" --enable-linux-netfilter"
		use qos && transparent+=" --enable-zph-qos --with-netfilter-conntrack"
	fi

	if use kernel_FreeBSD || use kernel_OpenBSD || use kernel_NetBSD ; then
		transparent+=" $(use_enable kqueue)"
		if use pf-transparent; then
			transparent+=" --enable-pf-transparent"
		elif use ipf-transparent; then
			transparent+=" --enable-ipf-transparent"
		fi
	fi

	tc-export CC AR

	econf \
		--sysconfdir=/etc/squid \
		--libexecdir=/usr/libexec/squid \
		--localstatedir=/var \
		--with-pidfile=/run/squid.pid \
		--datadir=/usr/share/squid \
		--with-logdir=/var/log/squid \
		--with-default-user=squid \
		--enable-removal-policies="lru,heap" \
		--enable-storeio="${storeio_modules}" \
		--enable-disk-io \
		--enable-auth \
		--enable-auth-basic="${basic_modules}" \
		--enable-auth-digest="${digest_modules}" \
		--enable-auth-ntlm="${ntlm_modules}" \
		--enable-auth-negotiate="${negotiate_modules}" \
		--enable-external-acl-helpers="${ext_helpers}" \
		--enable-log-daemon-helpers \
		--enable-url-rewrite-helpers \
		--enable-cache-digests \
		--enable-delay-pools \
		--enable-eui \
		--enable-icmp \
		--enable-follow-x-forwarded-for \
		--with-large-files \
		--disable-strict-error-checking \
		--disable-arch-native \
		$(use_with caps libcap) \
		$(use_enable ipv6) \
		$(use_enable snmp) \
		$(use_enable ssl) \
		$(use_with ssl nettle) \
		$(use_enable ssl-crtd) \
		$(use_enable icap-client) \
		$(use_enable ecap) \
		$(use_enable esi) \
		$(use_enable htcp) \
		$(use_enable wccp) \
		$(use_enable wccpv2) \
		${transparent} \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	# need suid root for looking into /etc/shadow
	fowners root:squid /usr/libexec/squid/basic_ncsa_auth
	fperms 4750 /usr/libexec/squid/basic_ncsa_auth
	if use pam; then
		fowners root:squid /usr/libexec/squid/basic_pam_auth
		fperms 4750 /usr/libexec/squid/basic_pam_auth
	fi
	# pinger needs suid as well
	fowners root:squid /usr/libexec/squid/pinger
	fperms 4750 /usr/libexec/squid/pinger

	# cleanup
	rm -f "${D}"/usr/bin/Run*
	rm -rf "${D}"/run/squid "${D}"/var/cache/squid

	dodoc CONTRIBUTORS CREDITS ChangeLog INSTALL QUICKSTART README SPONSORS doc/*.txt
	newdoc helpers/negotiate_auth/kerberos/README README.kerberos
	newdoc helpers/basic_auth/MSNT-multi-domain/README.txt README.MSNT-multi-domain
	newdoc helpers/basic_auth/LDAP/README README.LDAP
	newdoc helpers/basic_auth/RADIUS/README README.RADIUS
	newdoc helpers/external_acl/kerberos_ldap_group/README README.kerberos_ldap_group
	newdoc tools/purge/README README.purge
	newdoc tools/helper-mux.README README.helper-mux
	dohtml RELEASENOTES.html

	newpamd "${FILESDIR}/squid.pam" squid
	newconfd "${FILESDIR}/squid.confd-r1" squid
	newinitd "${FILESDIR}/squid.initd-r4" squid
	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/squid.logrotate" squid
	else
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}/squid.cron" squid.cron
	fi

	diropts -m0750 -o squid -g squid
	keepdir /var/log/squid /etc/ssl/squid /var/lib/squid
}

pkg_postinst() {
	if [[ $(get_version_component_range 1 ${REPLACING_VERSIONS}) -lt 3 ]] || \
		[[ $(get_version_component_range 2 ${REPLACING_VERSIONS}) -lt 4 ]]; then
		elog "Please read the release notes at:"
		elog "  http://www.squid-cache.org/Versions/v3/3.4/RELEASENOTES.html"
		echo
	fi
}
