# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"
inherit db-use eutils flag-o-matic multilib ssl-cert versionator toolchain-funcs user

DESCRIPTION="LDAP suite of application and development tools"
HOMEPAGE="http://www.OpenLDAP.org/"
SRC_URI="mirror://openldap/openldap-release/${P}.tgz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"

IUSE_DAEMON="crypt icu samba slp tcpd experimental minimal"
IUSE_BACKEND="+berkdb"
IUSE_OVERLAY="overlays perl"
IUSE_OPTIONAL="gnutls iodbc sasl ssl odbc debug ipv6 +syslog selinux"
IUSE_CONTRIB="smbkrb5passwd kerberos"
IUSE_CONTRIB="${IUSE_CONTRIB} -cxx"
IUSE="${IUSE_DAEMON} ${IUSE_BACKEND} ${IUSE_OVERLAY} ${IUSE_OPTIONAL} ${IUSE_CONTRIB}"

# openssl is needed to generate lanman-passwords required by samba
RDEPEND="sys-libs/ncurses
	sys-devel/libtool
	icu? ( dev-libs/icu )
	tcpd? ( sys-apps/tcp-wrappers )
	ssl? ( !gnutls? ( dev-libs/openssl )
		gnutls? ( <net-libs/gnutls-3 ) )
	sasl? ( dev-libs/cyrus-sasl )
	!minimal? (
		odbc? ( !iodbc? ( dev-db/unixODBC )
			iodbc? ( dev-db/libiodbc ) )
		slp? ( net-libs/openslp )
		perl? ( dev-lang/perl[-build] )
		samba? ( dev-libs/openssl )
		berkdb? ( sys-libs/db )
		smbkrb5passwd? (
			dev-libs/openssl
			app-crypt/heimdal )
		kerberos? ( virtual/krb5 )
		cxx? ( dev-libs/cyrus-sasl )
	)
	selinux? ( sec-policy/selinux-ldap )"
DEPEND="${RDEPEND}"

# for tracking versions
OPENLDAP_VERSIONTAG=".version-tag"
OPENLDAP_DEFAULTDIR_VERSIONTAG="/var/lib/openldap-data"

openldap_filecount() {
	local dir="$1"
	find "${dir}" -type f ! -name '.*' ! -name 'DB_CONFIG*' | wc -l
}

openldap_find_versiontags() {
	# scan for all datadirs
	openldap_datadirs=""
	if [ -f "${ROOT}"/etc/openldap/slapd.conf ]; then
		openldap_datadirs="$(awk '{if($1 == "directory") print $2 }' ${ROOT}/etc/openldap/slapd.conf)"
	fi
	openldap_datadirs="${openldap_datadirs} ${OPENLDAP_DEFAULTDIR_VERSIONTAG}"

	einfo
	einfo "Scanning datadir(s) from slapd.conf and"
	einfo "the default installdir for Versiontags"
	einfo "(${OPENLDAP_DEFAULTDIR_VERSIONTAG} may appear twice)"
	einfo

	# scan datadirs if we have a version tag
	openldap_found_tag=0
	have_files=0
	for each in ${openldap_datadirs}; do
		CURRENT_TAGDIR=${ROOT}`echo ${each} | sed "s:\/::"`
		CURRENT_TAG=${CURRENT_TAGDIR}/${OPENLDAP_VERSIONTAG}
		if [ -d ${CURRENT_TAGDIR} ] &&	[ ${openldap_found_tag} == 0 ] ; then
			einfo "- Checking ${each}..."
			if [ -r ${CURRENT_TAG} ] ; then
				# yey, we have one :)
				einfo "   Found Versiontag in ${each}"
				source ${CURRENT_TAG}
				if [ "${OLDPF}" == "" ] ; then
					eerror "Invalid Versiontag found in ${CURRENT_TAGDIR}"
					eerror "Please delete it"
					eerror
					die "Please kill the invalid versiontag in ${CURRENT_TAGDIR}"
				fi

				OLD_MAJOR=`get_version_component_range 2-3 ${OLDPF}`

				[ $(openldap_filecount ${CURRENT_TAGDIR}) -gt 0 ] && have_files=1

				# are we on the same branch?
				if [ "${OLD_MAJOR}" != "${PV:0:3}" ] ; then
					ewarn "   Versiontag doesn't match current major release!"
					if [[ "${have_files}" == "1" ]] ; then
						eerror "   Versiontag says other major and you (probably) have datafiles!"
						echo
						openldap_upgrade_howto
					else
						einfo "   No real problem, seems there's no database."
					fi
				else
					einfo "   Versiontag is fine here :)"
				fi
			else
				einfo "   Non-tagged dir ${each}"
				[ $(openldap_filecount ${each}) -gt 0 ] && have_files=1
				if [[ "${have_files}" == "1" ]] ; then
					einfo "   EEK! Non-empty non-tagged datadir, counting `ls -a ${each} | wc -l` files"
					echo

					eerror
					eerror "Your OpenLDAP Installation has a non tagged datadir that"
					eerror "possibly contains a database at ${CURRENT_TAGDIR}"
					eerror
					eerror "Please export data if any entered and empty or remove"
					eerror "the directory, installation has been stopped so you"
					eerror "can take required action"
					eerror
					eerror "For a HOWTO on exporting the data, see instructions in the ebuild"
					eerror
					die "Please move the datadir ${CURRENT_TAGDIR} away"
				fi
			fi
			einfo
		fi
	done
	[ "${have_files}" == "1" ] && einfo "DB files present" || einfo "No DB files present"

	# Now we must check for the major version of sys-libs/db linked against.
	SLAPD_PATH=${ROOT}/usr/$(get_libdir)/openldap/slapd
	if [ "${have_files}" == "1" -a -f "${SLAPD_PATH}" ]; then
		OLDVER="$(/usr/bin/ldd ${SLAPD_PATH} \
			| awk '/libdb-/{gsub("^libdb-","",$1);gsub(".so$","",$1);print $1}')"
		NEWVER="$(use berkdb && db_findver sys-libs/db)"
		local fail=0
		if [ -z "${OLDVER}" -a -z "${NEWVER}" ]; then
			:
			# Nothing wrong here.
		elif [ -z "${OLDVER}" -a -n "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was not built against"
			eerror "	any version of sys-libs/db, but the new one will build"
			eerror "	against	${NEWVER} and your database may be inaccessible."
			echo
			fail=1
		elif [ -n "${OLDVER}" -a -z "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will not be"
			eerror "	built against any version and your database may be"
			eerror "	inaccessible."
			echo
			fail=1
		elif [ "${OLDVER}" != "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will build against"
			eerror "	${NEWVER} and your database would be inaccessible."
			echo
			fail=1
		fi
		[ "${fail}" == "1" ] && openldap_upgrade_howto
	fi

	echo
	einfo
	einfo "All datadirs are fine, proceeding with merge now..."
	einfo
}

openldap_upgrade_howto() {
	eerror
	eerror "A (possible old) installation of OpenLDAP was detected,"
	eerror "installation will not proceed for now."
	eerror
	eerror "As major version upgrades can corrupt your database,"
	eerror "you need to dump your database and re-create it afterwards."
	eerror
	eerror "Additionally, rebuilding against different major versions of the"
	eerror "sys-libs/db libraries will cause your database to be inaccessible."
	eerror ""
	d="$(date -u +%s)"
	l="/root/ldapdump.${d}"
	i="${l}.raw"
	eerror " 1. /etc/init.d/slurpd stop ; /etc/init.d/slapd stop"
	eerror " 2. slapcat -l ${i}"
	eerror " 3. egrep -v '^(entry|context)CSN:' <${i} >${l}"
	eerror " 4. mv /var/lib/openldap-data/ /var/lib/openldap-data-backup/"
	eerror " 5. emerge --update \=net-nds/${PF}"
	eerror " 6. etc-update, and ensure that you apply the changes"
	eerror " 7. slapadd -l ${l}"
	eerror " 8. chown ldap:ldap /var/lib/openldap-data/*"
	eerror " 9. /etc/init.d/slapd start"
	eerror "10. check that your data is intact."
	eerror "11. set up the new replication system."
	eerror
	if [ "${FORCE_UPGRADE}" != "1" ]; then
		die "You need to upgrade your database first"
	else
		eerror "You have the magical FORCE_UPGRADE=1 in place."
		eerror "Don't say you weren't warned about data loss."
	fi
}

pkg_setup() {
	if ! use sasl && use cxx ; then
		die "To build the ldapc++ library you must emerge openldap with sasl support"
	fi
	if use minimal && has_version "net-nds/openldap" && built_with_use net-nds/openldap minimal ; then
		einfo
		einfo "Skipping scan for previous datadirs as requested by minimal useflag"
		einfo
	else
		openldap_find_versiontags
	fi

	enewgroup ldap 439
	enewuser ldap 439 -1 /usr/$(get_libdir)/openldap ldap
}

src_prepare() {
	# ensure correct SLAPI path by default
	sed -i -e 's,\(#define LDAPI_SOCK\).*,\1 "/var/run/openldap/slapd.sock",' \
		"${S}"/include/ldap_defaults.h

	epatch "${FILESDIR}"/${PN}-2.4.17-gcc44.patch

	epatch \
		"${FILESDIR}"/${PN}-2.2.14-perlthreadsfix.patch \
		"${FILESDIR}"/${PN}-2.4.15-ppolicy.patch

	# bug #116045 - still present in 2.4.19
	epatch "${FILESDIR}"/${PN}-2.4.19-contrib-smbk5pwd.patch

	# bug #189817
	epatch "${FILESDIR}"/${PN}-2.4.11-libldap_r.patch

	# bug #233633
	epatch "${FILESDIR}"/${PN}-2.4.17-fix-lmpasswd-gnutls-symbols.patch

	cd "${S}"/build
	einfo "Making sure upstream build strip does not do stripping too early"
	sed -i.orig \
		-e '/^STRIP/s,-s,,g' \
		top.mk || die "Failed to block stripping"

	# wrong assumption that /bin/sh is /bin/bash
	sed -i \
		-e 's|/bin/sh|/bin/bash|g' \
		"${S}"/tests/scripts/* || die "sed failed"
}

build_contrib_module() {
	lt="${S}/libtool"
	# <dir> <sources> <outputname>
	cd "${S}/contrib/slapd-modules/$1"
	einfo "Compiling contrib-module: $3"
	# Make sure it's uppercase
	local define_name="$(echo "SLAPD_OVER_${1}" | LC_ALL=C tr '[:lower:]' '[:upper:]')"
	"${lt}" --mode=compile --tag=CC \
		"${CC}" \
		-D${define_name}=SLAPD_MOD_DYNAMIC \
		-I../../../include -I../../../servers/slapd ${CFLAGS} \
		-o ${2%.c}.lo -c $2 || die "compiling $3 failed"
	einfo "Linking contrib-module: $3"
	"${lt}" --mode=link --tag=CC \
		"${CC}" -module \
		${CFLAGS} \
		${LDFLAGS} \
		-rpath /usr/$(get_libdir)/openldap/openldap \
		-o $3.la ${2%.c}.lo || die "linking $3 failed"
}

src_configure() {
	local myconf

	#Fix for glibc-2.8 and ucred. Bug 228457.
	append-flags -D_GNU_SOURCE

	use debug && myconf="${myconf} $(use_enable debug)"

	# ICU usage is not configurable
	export ac_cv_header_unicode_utypes_h="$(use icu && echo yes || echo no)"

	if ! use minimal ; then
		# backends
		myconf="${myconf} --enable-slapd"
		if use berkdb ; then
			einfo "Using Berkeley DB for local backend"
			myconf="${myconf} --enable-bdb --enable-hdb"
			# We need to include the slotted db.h dir for FreeBSD
			append-cppflags -I$(db_includedir)
		else
			ewarn
			ewarn "Note: if you disable berkdb, you can only use remote-backends!"
			ewarn
			ebeep 5
			myconf="${myconf} --disable-bdb --disable-hdb"
		fi
		for backend in dnssrv ldap meta monitor null passwd relay shell sock; do
			myconf="${myconf} --enable-${backend}=mod"
		done

		myconf="${myconf} $(use_enable perl perl mod)"

		myconf="${myconf} $(use_enable odbc sql mod)"
		if use odbc ; then
			local odbc_lib="unixodbc"
			use iodbc && odbc_lib="iodbc"
			myconf="${myconf} --with-odbc=${odbc_lib}"
		fi

		# slapd options
		myconf="${myconf} $(use_enable crypt) $(use_enable slp)"
		myconf="${myconf} $(use_enable samba lmpasswd) $(use_enable syslog)"
		if use experimental ; then
			myconf="${myconf} --enable-dynacl"
			myconf="${myconf} --enable-aci=mod"
		fi
		for option in aci cleartext modules rewrite rlookups slapi; do
			myconf="${myconf} --enable-${option}"
		done

		# slapd overlay options
		# Compile-in the syncprov, the others as module
		myconf="${myconf} --enable-syncprov=yes"
		use overlays && myconf="${myconf} --enable-overlays=mod"

	else
		myconf="${myconf} --disable-slapd --disable-bdb --disable-hdb"
		myconf="${myconf} --disable-overlays --disable-syslog"
	fi

	# basic functionality stuff
	myconf="${myconf} $(use_enable ipv6)"
	myconf="${myconf} $(use_with sasl cyrus-sasl) $(use_enable sasl spasswd)"
	myconf="${myconf} $(use_enable tcpd wrappers)"

	local ssl_lib="no"
	if use ssl || ( use ! minimal && use samba ) ; then
		ssl_lib="openssl"
		use gnutls && ssl_lib="gnutls"
	fi

	myconf="${myconf} --with-tls=${ssl_lib}"

	for basicflag in dynamic local proctitle shared static; do
		myconf="${myconf} --enable-${basicflag}"
	done

	tc-export CC AR CXX
	STRIP=/bin/true \
	econf \
		--libexecdir=/usr/$(get_libdir)/openldap \
		${myconf} || die "econf failed"
}

src_configure_cxx() {
	# This needs the libraries built by the first build run.
	# So we have to run it AFTER the main build, not just after the main
	# configure.
	if ! use minimal ; then
		 if use cxx ; then
		 	local myconf_ldapcpp
		 	myconf_ldapcpp="${myconf_ldapcpp} --with-ldap-includes=../../include"
		 	cd "${S}/contrib/ldapc++"
		 	OLD_LDFLAGS="$LDFLAGS"
		 	OLD_CPPFLAGS="$CPPFLAGS"
		 	append-ldflags -L../../libraries/liblber/.libs -L../../libraries/libldap/.libs
		 	append-ldflags -L../../../libraries/liblber/.libs -L../../../libraries/libldap/.libs
		 	append-cppflags -I../../../include
		 	econf ${myconf_ldapcpp} \
		 		CC="${CC}" \
		 		CXX="${CXX}" \
		 		|| die "econf ldapc++ failed"
		 	CPPFLAGS="$OLD_CPPFLAGS"
			LDFLAGS="${OLD_LDFLAGS}"
		 fi
	fi
}

src_compile() {
	emake depend || die "emake depend failed"
	emake CC="${CC}" AR="${AR}" || die "emake failed"
	lt="${S}/libtool"
	export echo="echo"

	if ! use minimal ; then
		 if use cxx ; then
		 	einfo "Building contrib library: ldapc++"
			src_configure_cxx
		 	cd "${S}/contrib/ldapc++"
		 	emake \
		 		CC="${CC}" CXX="${CXX}" \
		 		|| die "emake ldapc++ failed"
		 fi

		if use smbkrb5passwd ; then
			einfo "Building contrib-module: smbk5pwd"
			cd "${S}/contrib/slapd-modules/smbk5pwd"

			emake \
				DEFS="-DDO_SAMBA -DDO_KRB5" \
				KRB5_INC="$(krb5-config --cflags)" \
				CC="${CC}" libexecdir="/usr/$(get_libdir)/openldap" \
				|| die "emake smbk5pwd failed"
		fi

		if use kerberos ; then
			cd "${S}/contrib/slapd-modules/passwd"
			einfo "Compiling contrib-module: pw-kerberos"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I../../../include \
				${CFLAGS} \
				$(krb5-config --cflags) \
				-DHAVE_KRB5 \
				-o kerberos.lo \
				-c kerberos.c || die "compiling pw-kerberos failed"
			einfo "Linking contrib-module: pw-kerberos"
			"${lt}" --mode=link --tag=CC \
				"${CC}" -module \
				${CFLAGS} \
				${LDFLAGS} \
				-rpath /usr/$(get_libdir)/openldap/openldap \
				-o pw-kerberos.la \
				kerberos.lo || die "linking pw-kerberos failed"
		fi
		# We could build pw-radius if GNURadius would install radlib.h
		cd "${S}/contrib/slapd-modules/passwd"
		einfo "Compiling contrib-module: pw-netscape"
		"${lt}" --mode=compile --tag=CC \
			"${CC}" \
			-I../../../include \
			${CFLAGS} \
			-o netscape.lo \
			-c netscape.c || die "compiling pw-netscape failed"
		einfo "Linking contrib-module: pw-netscape"
		"${lt}" --mode=link --tag=CC \
			"${CC}" -module \
			${CFLAGS} \
			${LDFLAGS} \
			-rpath /usr/$(get_libdir)/openldap/openldap \
			-o pw-netscape.la \
			netscape.lo || die "linking pw-netscape failed"

		build_contrib_module "addpartial" "addpartial-overlay.c" "addpartial-overlay"
		build_contrib_module "allop" "allop.c" "overlay-allop"
		build_contrib_module "allowed" "allowed.c" "allowed"
		build_contrib_module "autogroup" "autogroup.c" "autogroup"
		build_contrib_module "denyop" "denyop.c" "denyop-overlay"
		build_contrib_module "dsaschema" "dsaschema.c" "dsaschema-plugin"
		# lastmod may not play well with other overlays
		build_contrib_module "lastmod" "lastmod.c" "lastmod"
		build_contrib_module "nops" "nops.c" "nops-overlay"
	    build_contrib_module "trace" "trace.c" "trace"
		# build slapi-plugins
		cd "${S}/contrib/slapi-plugins/addrdnvalues"
		einfo "Building contrib-module: addrdnvalues plugin"
		"${CC}" -shared \
			-I../../../include \
			${CFLAGS} \
			-fPIC \
			${LDFLAGS} \
			-o libaddrdnvalues-plugin.so \
			addrdnvalues.c || die "Building libaddrdnvalues-plugin.so failed"

	fi
}

src_test() {
	cd tests ; make tests || die "make tests failed"
}

src_install() {
	lt="${S}/libtool"
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README "${FILESDIR}"/DB_CONFIG.fast.example
	docinto rfc ; dodoc doc/rfc/*.txt

	# openldap modules go here
	# TODO: write some code to populate slapd.conf with moduleload statements
	keepdir /usr/$(get_libdir)/openldap/openldap/

	# initial data storage dir
	keepdir /var/lib/openldap-data
	fowners ldap:ldap /var/lib/openldap-data
	fperms 0700 /var/lib/openldap-data

	echo "OLDPF='${PF}'" > "${D}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
	echo "# do NOT delete this. it is used"	>> "${D}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
	echo "# to track versions for upgrading." >> "${D}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"

	# change slapd.pid location in configuration file
	keepdir /var/run/openldap
	fowners ldap:ldap /var/run/openldap
	fperms 0755 /var/run/openldap

	if ! use minimal; then
		# use our config
		rm "${D}"etc/openldap/slapd.conf
		insinto /etc/openldap
		newins "${FILESDIR}"/${PN}-2.3.34-slapd-conf slapd.conf
		configfile="${D}"etc/openldap/slapd.conf

		# populate with built backends
		ebegin "populate config with built backends"
		for x in "${D}"usr/$(get_libdir)/openldap/openldap/back_*.so; do
			elog "Adding $(basename ${x})"
			sed -e "/###INSERTDYNAMICMODULESHERE###$/a# moduleload\t$(basename ${x})" -i "${configfile}"
		done
		sed -e "s:###INSERTDYNAMICMODULESHERE###$:# modulepath\t/usr/$(get_libdir)/openldap/openldap:" -i "${configfile}"
		fowners root:ldap /etc/openldap/slapd.conf
		fperms 0640 /etc/openldap/slapd.conf
		cp "${configfile}" "${configfile}".default
		eend

		# install our own init scripts
		newinitd "${FILESDIR}"/slapd-initd slapd
		newconfd "${FILESDIR}"/slapd-confd slapd
		if [ $(get_libdir) != lib ]; then
			sed -e "s,/usr/lib/,/usr/$(get_libdir)/," -i "${D}"etc/init.d/slapd
		fi

		 if use cxx ; then
		 	einfo "Install the ldapc++ library"
		 	cd "${S}/contrib/ldapc++"
		 	emake DESTDIR="${D}" libexecdir="/usr/$(get_libdir)/openldap" install || die "emake install ldapc++ failed"
		 	newdoc README ldapc++-README
		 fi

		if use smbkrb5passwd ; then
			einfo "Install the smbk5pwd module"
			cd "${S}/contrib/slapd-modules/smbk5pwd"
			emake DESTDIR="${D}" libexecdir="/usr/$(get_libdir)/openldap" install || die "emake install smbk5pwd failed"
			newdoc README smbk5pwd-README
		fi

		einfo "Installing contrib modules"
		cd "${S}/contrib/slapd-modules"
		for l in */*.la; do
			"${lt}" --mode=install cp ${l} \
				"${D}"usr/$(get_libdir)/openldap/openldap || \
				die "installing ${l} failed"
		done
		docinto contrib
		newdoc addpartial/README addpartial-README
		newdoc allop/README allop-README
		doman allop/slapo-allop.5
		newdoc autogroup/README autogroup-README
		newdoc denyop/denyop.c denyop-denyop.c
		newdoc dsaschema/README dsaschema-README
		doman lastmod/slapo-lastmod.5
		doman nops/slapo-nops.5
		newdoc passwd/README passwd-README
		cd "${S}/contrib/slapi-plugins"
		insinto /usr/$(get_libdir)/openldap/openldap
		doins  */*.so
		docinto contrib
		newdoc addrdnvalues/README addrdnvalues-README
	fi
}

pkg_preinst() {
	# keep old libs if any
	preserve_old_lib usr/$(get_libdir)/{libldap,libldap_r,liblber}-2.3.so.0
}

pkg_postinst() {
	if ! use minimal ; then
		# You cannot build SSL certificates during src_install that will make
		# binary packages containing your SSL key, which is both a security risk
		# and a misconfiguration if multiple machines use the same key and cert.
		if use ssl; then
			install_cert /etc/openldap/ssl/ldap
			chown ldap:ldap "${ROOT}"etc/openldap/ssl/ldap.*
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "add 'TLS_REQCERT never' if you want to use them."
		fi

		# These lines force the permissions of various content to be correct
		chown ldap:ldap "${ROOT}"var/run/openldap
		chmod 0755 "${ROOT}"var/run/openldap
		chown root:ldap "${ROOT}"etc/openldap/slapd.conf{,.default}
		chmod 0640 "${ROOT}"etc/openldap/slapd.conf{,.default}
		chown ldap:ldap "${ROOT}"var/lib/openldap-{data,ldbm}
	fi

	elog "Getting started using OpenLDAP? There is some documentation available:"
	elog "Gentoo Guide to OpenLDAP Authentication"
	elog "(http://www.gentoo.org/doc/en/ldap-howto.xml)"
	elog "---"
	elog "An example file for tuning BDB backends with openldap is"
	elog "DB_CONFIG.fast.example in /usr/share/doc/${PF}/"

	preserve_old_lib_notify /usr/$(get_libdir)/{liblber,libldap,libldap_r}-2.3.so.0
}
