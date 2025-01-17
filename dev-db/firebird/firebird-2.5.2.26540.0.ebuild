# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit flag-o-matic eutils autotools multilib user versionator

MY_P=${PN/f/F}-$(replace_version_separator 4 -)
#MY_P=${PN/f/F}-${PV/_rc/-ReleaseCandidate}

DESCRIPTION="A relational database offering many ANSI SQL:2003 and some SQL:2008 features"
HOMEPAGE="http://www.firebirdsql.org/"
SRC_URI="mirror://sourceforge/firebird/${MY_P}.tar.bz2
	 doc? (	ftp://ftpc.inprise.com/pub/interbase/techpubs/ib_b60_doc.zip )"

LICENSE="IDPL Interbase-1.0"
SLOT="0"
KEYWORDS="~amd64 -ia64 ~x86"
IUSE="doc client superserver xinetd examples debug"
RESTRICT="userpriv"

RDEPEND="dev-libs/libedit
	dev-libs/icu"
DEPEND="${RDEPEND}
	>=dev-util/btyacc-3.0-r2
	doc? ( app-arch/unzip )"
RDEPEND="${RDEPEND}
	xinetd? ( virtual/inetd )
	!sys-cluster/ganglia"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if use client && use superserver ; then
		die "Use flags client and superserver cannot be used together"
	fi
	if use client && use xinetd ; then
		die "Use flags client and xinetd cannot be used together"
	fi
	if use superserver && use xinetd ; then
		die "Use flags superserver and xinetd cannot be used together"
	fi
}

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /usr/$(get_libdir)/firebird firebird
}

function check_sed() {
	MSG="sed of $3, required $2 lines modified $1"
	einfo "${MSG}"
	[[ $1 -ge $2 ]] || die "${MSG}"
}

src_unpack() {
	if use doc; then
		# Unpack docs
		mkdir "${WORKDIR}/manuals"
		cd "${WORKDIR}/manuals"
		unpack ib_b60_doc.zip
		cd "${WORKDIR}"
	fi
	unpack "${MY_P}.tar.bz2"
	cd "${S}"
}

src_prepare() {
	# This patch might be portable, and not need to be duplicated per version
	# also might no longer be necessary to patch deps or libs, just flags
	epatch "${FILESDIR}/${PN}-2.5.1.26351.0-deps-flags.patch"

	use client && epatch "${FILESDIR}/${PN}-2.5.1.26351.0-client.patch"
	if ! use superserver ; then
		epatch "${FILESDIR}/${PN}-2.5.1.26351.0-superclassic.patch"
	fi

	# Rename references to isql to fbsql
	# sed vs patch for portability and addtional location changes
	check_sed "$(sed -i -e 's:"isql :"fbsql :w /dev/stdout' \
		src/isql/isql.epp | wc -l)" "1" "src/isql/isql.epp" # 1 line
	check_sed "$(sed -i -e 's:isql :fbsql :w /dev/stdout' \
		src/msgs/history2.sql | wc -l)" "4" "src/msgs/history2.sql" # 4 lines
	check_sed "$(sed -i -e 's:--- ISQL:--- FBSQL:w /dev/stdout' \
		-e 's:isql :fbsql :w /dev/stdout' \
		-e 's:ISQL :FBSQL :w /dev/stdout' \
		src/msgs/messages2.sql | wc -l)" "6" "src/msgs/messages2.sql" # 6 lines

	find "${S}" -name \*.sh -print0 | xargs -0 chmod +x
	rm -rf "${S}"/extern/{btyacc,editline,icu}

	eautoreconf
}

src_configure() {
	filter-flags -fprefetch-loop-arrays
	filter-mfpmath sse

	econf --prefix=/usr/$(get_libdir)/firebird \
		$(use_enable superserver superserver) \
		$(use_enable debug) \
		--with-editline \
		--with-system-editline \
		--with-system-icu \
		--with-fbbin=/usr/bin \
		--with-fbsbin=/usr/sbin \
		--with-fbconf=/etc/${PN} \
		--with-fblib=/usr/$(get_libdir) \
		--with-fbinclude=/usr/include \
		--with-fbdoc=/usr/share/doc/${P} \
		--with-fbudf=/usr/$(get_libdir)/${PN}/UDF \
		--with-fbsample=/usr/share/doc/${P}/examples \
		--with-fbsample-db=/usr/share/doc/${P}/examples/db \
		--with-fbhelp=/usr/$(get_libdir)/${PN}/help \
		--with-fbintl=/usr/$(get_libdir)/${PN}/intl \
		--with-fbmisc=/usr/share/${PN} \
		--with-fbsecure-db=/etc/${PN} \
		--with-fbmsg=/usr/$(get_libdir)/${PN} \
		--with-fblog=/var/log/${PN}/ \
		--with-fbglock=/var/run/${PN} \
		--with-fbplugins=/usr/$(get_libdir)/${PN}/plugins \
		--with-gnu-ld \
		${myconf}
}

src_compile() {
	MAKEOPTS="${MAKEOPTS/-j*/-j1} ${MAKEOPTS/-j/CPU=}"
	emake
}

src_install() {
	cd "${S}/gen/${PN}"

	if use doc; then
		dodoc "${S}"/doc/*.pdf
		find "${WORKDIR}"/manuals -type f -iname "*.pdf" -exec dodoc '{}' + || die
	fi

	insinto /usr/include
	doins include/*

	rm lib/libfbstatic.a

	insinto /usr/$(get_libdir)
	dolib.so lib/*.so*

	# links for backwards compatibility
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so.0
	dosym libfbclient.so /usr/$(get_libdir)/libfbclient.so.1

	insinto /usr/$(get_libdir)/${PN}
	doins *.msg

	use client && return

	einfo "Renaming isql -> fbsql"
	mv bin/isql bin/fbsql

	local bins="fbsql fbsvcmgr fbtracemgr gbak gdef gfix gpre gsec gstat nbackup qli"
	for bin in ${bins[@]}; do
		dobin bin/${bin}
	done

	dosbin bin/fb_lock_print
	# SuperServer
	if use superserver ; then
		dosbin bin/{fbguard,fbserver}
	# ClassicServer
	elif use xinetd ; then
		dosbin bin/fb_inet_server
	# SuperClassic
	else
		dosbin bin/{fbguard,fb_smp_server}

		#Temp should not be necessary, need to patch/fix
		dosym "${D}"/usr/$(get_libdir)/libib_util.so /usr/$(get_libdir)/${PN}/lib/libib_util.so
	fi

	exeinto /usr/bin/${PN}
	exeopts -m0755
	doexe bin/{changeRunUser,restoreRootRunUser,changeDBAPassword}.sh

	insinto /usr/$(get_libdir)/${PN}/help
	doins help/help.fdb

	exeinto /usr/$(get_libdir)/firebird/intl
	dolib.so intl/libfbintl.so
	dosym "${D}"/usr/$(get_libdir)/libfbintl.so /usr/$(get_libdir)/${PN}/intl/fbintl
	dosym "${D}"/etc/firebird/fbintl.conf /usr/$(get_libdir)/${PN}/intl/fbintl.conf

	exeinto /usr/$(get_libdir)/${PN}/plugins
	dolib.so plugins/libfbtrace.so
	dosym "${D}"/usr/$(get_libdir)/libfbtrace.so /usr/$(get_libdir)/${PN}/plugins/libfbtrace.so

	exeinto /usr/$(get_libdir)/${PN}/UDF
	doexe UDF/*.so

	insinto /usr/share/${PN}/upgrade
	doins "${S}"/src/misc/upgrade/v2/*

	insinto /etc/${PN}
	insopts -m0644 -o firebird -g firebird
	doins ../install/misc/*.conf
	insopts -m0660 -o firebird -g firebird
	doins security2.fdb

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${PN}.xinetd" ${PN}
	else
		newinitd "${FILESDIR}/${PN}.init.d.2.5" ${PN}
		newconfd "${FILESDIR}/${PN}.conf.d.2.5" ${PN}
		fperms 640 /etc/conf.d/${PN}
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	diropts -m 755 -o firebird -g firebird
	dodir /var/log/${PN}
	dodir /var/run/${PN}
	keepdir /var/log/${PN}
	keepdir /var/run/${PN}

	use examples && docinto examples
}

pkg_postinst() {
	use client && return

	# Hack to fix ownership/perms
	chown -fR firebird:firebird "${ROOT}/etc/${PN}" "${ROOT}/usr/$(get_libdir)/${PN}"
	chmod 750 "${ROOT}/etc/${PN}"

	elog
	elog "Firebird is no longer installed in /opt. Binaries are in"
	elog "/usr/bin. The core, udfs, etc are in /usr/lib/firebird. Logs"
	elog "are in /var/log/firebird, and lock files in /var/run/firebird"
	elog "The command line tool isql has been renamed to fbsql."
	elog "Please report any problems or issues to bugs.gentoo.org."
	elog
}

pkg_config() {
	use client && return

	# if found /etc/security.gdb from previous install, backup, and restore as
	# /etc/security2.fdb
	if [ -f "${ROOT}/etc/firebird/security.gdb" ] ; then
		# if we have scurity2.fdb already, back it 1st
		if [ -f "${ROOT}/etc/firebird/security2.fdb" ] ; then
			cp "${ROOT}/etc/firebird/security2.fdb" "${ROOT}/etc/firebird/security2.fdb.old"
		fi
		gbak -B "${ROOT}/etc/firebird/security.gdb" "${ROOT}/etc/firebird/security.gbk"
		gbak -R "${ROOT}/etc/firebird/security.gbk" "${ROOT}/etc/firebird/security2.fdb"
		mv "${ROOT}/etc/firebird/security.gdb" "${ROOT}/etc/firebird/security.gdb.old"
		rm "${ROOT}/etc/firebird/security.gbk"

		# make sure they are readable only to firebird
		chown firebird:firebird "${ROOT}/etc/firebird/{security.*,security2.*}"
		chmod 660 "${ROOT}/etc/firebird/{security.*,security2.*}"

		einfo
		einfo "Converted old security.gdb to security2.fdb, security.gdb has been "
		einfo "renamed to security.gdb.old. if you had previous security2.fdb, "
		einfo "it's backed to security2.fdb.old (all under ${ROOT}/etc/firebird)."
		einfo
	fi

	# we need to enable local access to the server
	if [ ! -f "${ROOT}/etc/hosts.equiv" ] ; then
		touch "${ROOT}/etc/hosts.equiv"
		chown root:0 "${ROOT}/etc/hosts.equiv"
		chmod u=rw,go=r "${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost.localdomain' to the hosts.equiv file...
	if [ grep -q 'localhost.localdomain$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost.localdomain" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost.localdomain to ${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost' to the hosts.equiv file...
	if [ grep -q 'localhost$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost to ${ROOT}/etc/hosts.equiv"
	fi

	HS_NAME=`hostname`
	if [ grep -q ${HS_NAME} "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "${HS_NAME}" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added ${HS_NAME} to ${ROOT}/etc/hosts.equiv"
	fi

	einfo "If you're using UDFs, please remember to move them"
	einfo "to /usr/lib/firebird/UDF"
}
