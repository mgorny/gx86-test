# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit bsdmk freebsd multilib

DESCRIPTION="FreeBSD sbin utils"
SLOT="0"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
	SRC_URI="mirror://gentoo/${SBIN}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${LIBEXEC}.tar.bz2
		mirror://gentoo/${USBIN}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		build? ( mirror://gentoo/${SYS}.tar.bz2 )"
fi

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*[ipv6?,atm?,netware?]
	=sys-freebsd/freebsd-libexec-${RV}*
	>=dev-libs/expat-2.0.1
	ssl? ( dev-libs/openssl )
	>=dev-libs/libedit-20120311.3.0-r1
	sys-libs/readline
	|| (
		sys-process/cronie
		sys-process/vixie-cron
	)
	atm? ( net-analyzer/bsnmp )"
DEPEND="${RDEPEND}
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )
	=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/sbin"

IUSE="atm ipfilter +pf ipv6 build ssl +cxx netware"

pkg_setup() {
	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use cxx || mymakeopts="${mymakeopts} WITHOUT_CXX="
	use ipfilter || mymakeopts="${mymakeopts} WITHOUT_IPFILTER= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6= WITHOUT_INET6_SUPPORT="
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use pf || mymakeopts="${mymakeopts} WITHOUT_PF= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL="
}

REMOVE_SUBDIRS="dhclient pfctl pflogd rcorder resolvconf"

PATCHES=( "${FILESDIR}/${PN}-setXid.patch"
	"${FILESDIR}/${PN}-7.1-zlib.patch"
	"${FILESDIR}/${PN}-6.2-ldconfig.patch"
	"${FILESDIR}/${PN}-6.1-pr102701.patch"
	"${FILESDIR}/${PN}-bsdxml2expat.patch" )

src_prepare() {
	use build || ln -s "/usr/src/sys" "${WORKDIR}/sys"
}

src_install() {
	mymakeopts="${mymakeopts} GEOM_CLASS_DIR=/$(get_libdir)/geom "
	freebsd_src_install
	keepdir /var/log
	# Needed by ldconfig:
	keepdir /var/run

	# Maybe ship our own sysctl.conf so things like radvd work out of the box.
	# New wireless config method requires regdomain.xml in /etc
	cd "${WORKDIR}/etc/"
	insinto /etc
	doins minfree sysctl.conf regdomain.xml || die

	# initd script for idmapd
	newinitd "${FILESDIR}/idmapd.initd" idmapd

	# Install a crontab for adjkerntz
	insinto /etc/cron.d
	newins "${FILESDIR}/adjkerntz-crontab" adjkerntz

	# Install the periodic stuff (needs probably to be ported in a more
	# gentooish way)
	cd "${WORKDIR}/etc/periodic"

	doperiodic security \
		security/*.ipfwlimit \
		security/*.ipfwdenied || die

	use ipfilter && { doperiodic security \
		security/*.ipfdenied || die ; }

	use pf && { doperiodic security \
		security/*.pfdenied || die ; }
}
