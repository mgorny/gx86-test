# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

PYTHON_DEPEND="2"
PYTHON_USE_WITH="ncurses? xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

inherit eutils distutils systemd

DESCRIPTION="A lightweight wired and wireless network manager for Linux"
HOMEPAGE="https://launchpad.net/wicd"
SRC_URI="http://launchpad.net/wicd/1.7/${PV}/+download/${P}.tar.gz
	mac4lin? ( http://dev.gentoo.org/~anarchy/dist/wicd-mac4lin-icons.tar.xz )
	ambiance? ( http://freetimesblog.altervista.org/blog/wp-content/uploads/downloads/2010/05/Icone-Wicd-Lucid.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86"
IUSE="X ambiance +gtk ioctl libnotify mac4lin ncurses nls +pm-utils"

DEPEND="nls? ( dev-python/Babel )"
# Maybe virtual/dhcp would work, but there are enough problems with
# net-misc/dhcp that I want net-misc/dhcpcd to be guarenteed to be considered
# first if none are installed.
RDEPEND="
	dev-python/dbus-python
	X? (
		gtk? ( dev-python/pygtk )
		|| (
			x11-misc/ktsuss
			x11-libs/gksu
			kde-base/kdesu
			)
	)
	|| (
		net-misc/dhcpcd
		net-misc/dhcp
		net-misc/pump
	)
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	|| (
		sys-apps/net-tools
		sys-apps/ethtool
	)
	!gtk? ( dev-python/pygobject:2 )
	ioctl? ( dev-python/python-iwscan dev-python/python-wpactrl )
	libnotify? ( dev-python/notify-python )
	ncurses? (
		dev-python/urwid
		dev-python/pygobject:2
	)
	pm-utils? ( >=sys-power/pm-utils-1.1.1 )
	"
DOCS="CHANGES NEWS AUTHORS README"

src_prepare() {
	# Fix bug 441966 (urwid-1.1.0 compatibility)
	epatch "${FILESDIR}"/${P}-urwid.patch
	epatch "${FILESDIR}"/${P}-second-urwid.patch
	epatch "${FILESDIR}"/${PN}-1.7.1_beta2-init.patch
	epatch "${FILESDIR}"/${PN}-init-sve-start.patch
	# Add a template for hex psk's and wpa (Bug 306423)
	epatch "${FILESDIR}"/${PN}-1.7.1_pre20111210-wpa-psk-hex-template.patch
	# Fix bug 416579 (should be included in next release)
	epatch "${FILESDIR}"/${P}-fix-dbus-error.patch
	# get rid of opts variable to fix bug 381885
	sed -i "/opts/d" "in/init=gentoo=wicd.in" || die
	# Make init script provide net per bug 405775
	epatch "${FILESDIR}"/${PN}-1.7.1-provide-net.patch
	# Need to ensure that generated scripts use Python 2 at run time.
	sed -e "s:self.python = '/usr/bin/python':self.python = '/usr/bin/python2':" \
	  -i setup.py || die "sed failed"
	if use nls; then
	  # Asturian is faulty with PyBabel
	  # (https://bugs.launchpad.net/wicd/+bug/928589)
	  rm po/ast.po
	else
	  # nuke translations
	  rm po/*.po
	fi
	python_copy_sources
}

src_configure() {
	local myconf
	use gtk || myconf="${myconf} --no-install-gtk"
	use libnotify || myconf="${myconf} --no-use-notifications"
	use ncurses || myconf="${myconf} --no-install-ncurses"
	use pm-utils || myconf="${myconf} --no-install-pmutils"
	configuration() {
		$(PYTHON) ./setup.py configure --no-install-docs --resume=/usr/share/wicd/scripts/ --suspend=/usr/share/wicd/scripts/ --verbose ${myconf}
	}
	python_execute_function -s configuration
}

src_install() {
	distutils_src_install
	keepdir /var/lib/wicd/configurations \
		|| die "keepdir failed, critical for this app"
	keepdir /etc/wicd/scripts/{postconnect,disconnect,preconnect} \
		|| die "keepdir failed, critical for this app"
	keepdir /var/log/wicd \
		|| die "keepdir failed, critical for this app"
	use nls || rm -rf "${D}"/usr/share/locale
	systemd_dounit "${S}/other/wicd.service"

	if use mac4lin; then
		rm -rf "${D}"/usr/share/pixmaps/wicd || die "Failed to remove old icons"
		mv "${WORKDIR}"/wicd "${D}"/usr/share/pixmaps/
	fi
	if use ambiance; then
		# Overwrite tray icons with ambiance icon
		rm "${WORKDIR}/Icone Wicd Lucid"/signal*
		cp "${WORKDIR}/Icone Wicd Lucid"/*.png "${D}"/usr/share/pixmaps/wicd/
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "You may need to restart the dbus service after upgrading wicd."
	echo
	elog "To start wicd at boot, add /etc/init.d/wicd to a runlevel and:"
	elog "- Remove all net.* initscripts (except for net.lo) from all runlevels"
	elog "- Add these scripts to the RC_PLUG_SERVICES line in /etc/rc.conf"
	elog "(For example, rc_hotplug=\"!net.eth* !net.wlan*\")"
	# Maintainer's note: the consolekit use flag short circuits a dbus rule and
	# allows the connection. Else, you need to be in the group.
	if ! has_version sys-auth/consolekit; then
		ewarn "Wicd-1.6 and newer requires your user to be in the 'users' group. If"
		ewarn "you are not in that group, then modify /etc/dbus-1/system.d/wicd.conf"
	fi
}
