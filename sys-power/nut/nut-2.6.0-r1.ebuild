# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit autotools bash-completion eutils fixheadtails multilib user

MY_P=${P/_/-}

DESCRIPTION="Network-UPS Tools"
HOMEPAGE="http://www.networkupstools.org/"
# Nut mirrors are presently broken
SRC_URI="http://random.networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz
	 http://www.networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="cgi snmp usb selinux ssl tcpd xml"

RDEPEND="cgi? ( >=media-libs/gd-2[png] )
	snmp? ( net-analyzer/net-snmp )
	usb? ( virtual/libusb:0 )
	selinux? ( sec-policy/selinux-nut )
	ssl? ( >=dev-libs/openssl-1 )
	tcpd? ( sys-apps/tcp-wrappers )
	xml? ( >=net-libs/neon-0.25.0 )
	virtual/udev"
DEPEND="$RDEPEND
	>=sys-apps/sed-4
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

# public files should be 644 root:root
NUT_PUBLIC_FILES="/etc/nut/{ups,upssched}.conf"
# private files should be 640 root:nut - readable by nut, writeable by root,
NUT_PRIVATE_FILES="/etc/nut/{upsd.conf,upsd.users,upsmon.conf}"
# public files should be 644 root:root, only installed if USE=cgi
NUT_CGI_FILES="/etc/nut/{{hosts,upsset}.conf,upsstats{,-single}.html}"

pkg_setup() {
	enewgroup nut 84
	enewuser nut 84 -1 /var/lib/nut nut,uucp
	# As of udev-104, NUT must be in uucp and NOT in tty.
	gpasswd -d nut tty 2>/dev/null
	gpasswd -a nut uucp 2>/dev/null
	# in some cases on old systems it wasn't in the nut group either!
	gpasswd -a nut nut 2>/dev/null
	warningmsg ewarn
}

src_prepare() {
	ht_fix_file configure.in

	epatch "${FILESDIR}"/${PN}-2.4.1-no-libdummy.patch
	epatch "${FILESDIR}"/${PN}-2.4.3-lowspeed-buffer-size.patch

	sed -e "s:GD_LIBS.*=.*-L/usr/X11R6/lib \(.*\) -lXpm -lX11:GD_LIBS=\"\1:" \
		-i configure.in || die

	sed -e "s:52.nut-usbups.rules:70-nut-usbups.rules:" \
		-i scripts/udev/Makefile.am || die

	rm -f ltmain.sh m4/lt* m4/libtool.m4

	sed -i \
		-e 's:@LIBSSL_LDFLAGS@:@LIBSSL_LIBS@:' \
		lib/libupsclient{.pc,-config}.in || die #361685

	eautoreconf
}

src_configure() {
	local myconf

	if [ -n "${NUT_DRIVERS}" ]; then
		myconf="${myconf} --with-drivers=${NUT_DRIVERS// /,}"
	fi

	use cgi && myconf="${myconf} --with-cgipath=/usr/share/nut/cgi"

	# TODO: USE flag for sys-power/powerman
	econf \
		--sysconfdir=/etc/nut \
		--datarootdir=/usr/share/nut \
		--datadir=/usr/share/nut \
		--disable-static \
		--with-dev \
		$(use_with usb) \
		--without-hal \
		$(use_with snmp) \
		$(use_with xml neon) \
		--without-powerman \
		$(use_with ssl) \
		$(use_with tcpd wrap) \
		$(use_with cgi) \
		--with-statepath=/var/lib/nut \
		--with-drvpath=/$(get_libdir)/nut \
		--with-htmlpath=/usr/share/nut/html \
		--with-user=nut \
		--with-group=nut \
		--with-logfacility=LOG_DAEMON \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${D}" -name '*.la' -exec rm -f {} +

	dodir /sbin
	dosym /$(get_libdir)/nut/upsdrvctl /sbin/upsdrvctl
	# This needs to exist for the scripts
	dosym /$(get_libdir)/nut/upsdrvctl /usr/sbin/upsdrvctl

	if use cgi; then
		elog "CGI monitoring scripts are installed in /usr/share/nut/cgi."
		elog "copy them to your web server's ScriptPath to activate (this is a"
		elog "change from the old location)."
		elog "If you use lighttpd, see lighttpd_nut.conf in the documentation."
	fi

	# this must be done after all of the install phases
	for i in "${D}"/etc/nut/*.sample ; do
		mv "${i}" "${i/.sample/}"
	done

	dodoc AUTHORS ChangeLog docs/*.txt MAINTAINERS NEWS README TODO UPGRADING || die

	newdoc lib/README README.lib || die
	newdoc "${FILESDIR}"/lighttpd_nut.conf-2.2.0 lighttpd_nut.conf || die

	docinto cables
	dodoc docs/cables/* || die

	newinitd "${FILESDIR}"/nut-2.2.2-init.d-upsd upsd || die
	newinitd "${FILESDIR}"/nut-2.2.2-init.d-upsdrv upsdrv || die
	newinitd "${FILESDIR}"/nut-2.2.2-init.d-upsmon upsmon || die
	newinitd "${FILESDIR}"/nut.powerfail.initd nut.powerfail || die

	keepdir /var/lib/nut

	einfo "Setting up permissions on files and directories"
	fperms 0700 /var/lib/nut
	fowners nut:nut /var/lib/nut

	# Do not remove eval here, because the variables contain shell expansions.
	eval fperms 0640 ${NUT_PRIVATE_FILES}
	eval fowners root:nut ${NUT_PRIVATE_FILES}

	# Do not remove eval here, because the variables contain shell expansions.
	eval fperms 0644 ${NUT_PUBLIC_FILES}
	eval fowners root:root ${NUT_PUBLIC_FILES}

	# Do not remove eval here, because the variables contain shell expansions.
	if use cgi; then
		eval fperms 0644 ${NUT_CGI_FILES}
		eval fowners root:root ${NUT_CGI_FILES}
	fi

	# this is installed for 2.4 and fbsd guys
	if ! has_version virtual/udev; then
		einfo "Installing non-udev hotplug support"
		insinto /etc/hotplug/usb
		insopts -m 755
		doins scripts/hotplug/nut-usbups.hotplug
	fi

	dobashcompletion "${S}"/scripts/misc/nut.bash_completion
}

pkg_postinst() {
	# this is to ensure that everybody that installed old versions still has
	# correct permissions

	chown nut:nut "${ROOT}"/var/lib/nut 2>/dev/null
	chmod 0700 "${ROOT}"/var/lib/nut 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	eval chown root:nut "${ROOT}"${NUT_PRIVATE_FILES} 2>/dev/null
	eval chmod 0640 "${ROOT}"${NUT_PRIVATE_FILES} 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	eval chown root:root "${ROOT}"${NUT_PUBLIC_FILES} 2>/dev/null
	eval chmod 0644 "${ROOT}"${NUT_PUBLIC_FILES} 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	if use cgi; then
		eval chown root:root "${ROOT}"${NUT_CGI_FILES} 2>/dev/null
		eval chmod 0644 "${ROOT}"${NUT_CGI_FILES} 2>/dev/null
	fi

	warningmsg elog
}

warningmsg() {
	msgfunc="$1"
	[ -z "$msgfunc" ] && die "msgfunc not specified in call to warningmsg!"
	${msgfunc} "Please note that NUT now runs under the 'nut' user."
	${msgfunc} "NUT is in the uucp group for access to RS-232 UPS."
	${msgfunc} "However if you use a USB UPS you may need to look at the udev or"
	${msgfunc} "hotplug rules that are installed, and alter them suitably."
	${msgfunc} ''
	${msgfunc} "You are strongly advised to read the UPGRADING file provided by upstream."
	${msgfunc} ''
	${msgfunc} "Please note that upsdrv is NOT automatically started by upsd anymore."
	${msgfunc} "If you have multiple UPS units, you can use their NUT names to"
	${msgfunc} "have a service per UPS:"
	${msgfunc} "ln -s /etc/init.d/upsdrv /etc/init.d/upsdrv.\$UPSNAME"
	${msgfunc} ''
	${msgfunc} 'If you want apcupsd to power off your UPS when it'
	${msgfunc} 'shuts down your system in a power failure, you must'
	${msgfunc} 'add nut.powerfail to your shutdown runlevel:'
	${msgfunc} ''
	${msgfunc} 'rc-update add nut.powerfail shutdown'
	${msgfunc} ''

}
