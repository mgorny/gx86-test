# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools eutils gnome2 multilib pax-utils python-single-r1

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="http://cinnamon.linuxmint.com/"

MY_PV="${PV/_p/-UP}"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/linuxmint/Cinnamon/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
# bluetooth support dropped due bug #511648
IUSE="+l10n +networkmanager" #+bluetooth
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="amd64 x86"

COMMON_DEPEND="
	app-misc/ca-certificates
	dev-libs/dbus-glib
	>=dev-libs/glib-2.29.10:2
	>=dev-libs/gobject-introspection-0.10.1
	>=dev-libs/json-glib-0.13.2
	>=dev-libs/libcroco-0.6.2:0.6
	dev-libs/libxml2:2
	gnome-base/gconf:2[introspection]
	gnome-base/librsvg
	>=gnome-extra/cinnamon-desktop-1.0:0=[introspection]
	gnome-extra/cinnamon-menus[introspection]
	>=gnome-extra/cjs-1.9.0
	>=media-libs/clutter-1.7.5:1.0[introspection]
	media-libs/cogl:1.0=[introspection]
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/libcanberra
	media-sound/pulseaudio:0=[glib]
	net-libs/libsoup:2.4[introspection]
	>=sys-auth/polkit-0.100[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.0.0:3[introspection]
	x11-libs/pango[introspection]
	>=x11-libs/startup-notification-0.11
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	>=x11-wm/muffin-1.9.1[introspection]
	${PYTHON_DEPS}
	networkmanager? (
		gnome-base/libgnome-keyring
		>=net-misc/networkmanager-0.8.999[introspection] )
"
#bluetooth? ( >=net-wireless/gnome-bluetooth-3.1:=[introspection] )

# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. accountsservice is needed for GdmUserManager (0.6.14 needed for fast
#    user switching with gdm-3.1.x)
# 6. caribou needed for on-screen keyboard
# 7. xdg-utils needed for xdg-open, used by extension tool
# 8. gconf-python, imaging, lxml needed for cinnamon-settings
# 9. gnome-icon-theme-symbolic needed for various icons
# 10. pygobject needed for menu editor
# 11. nemo - default file manager, tightly integrated with cinnamon
# TODO(lxnay): fix error: libgnome-desktop/gnome-rr-labeler.h: No such file or directory
# note: needs gksu, not gksu-polkit, due to extensive use of --message/-m arg
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	|| ( sys-power/upower[introspection] sys-power/upower-pm-utils[introspection] )

	gnome-extra/cinnamon-session

	gnome-extra/cinnamon-settings-daemon

	>=sys-apps/accountsservice-0.6.14[introspection]

	>=app-accessibility/caribou-0.3

	x11-libs/gksu
	x11-misc/xdg-utils

	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python:2
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/pypam[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]

	x11-themes/gnome-themes-standard[gtk]
	x11-themes/gnome-icon-theme-symbolic

	gnome-extra/nemo
	gnome-extra/cinnamon-control-center
	gnome-extra/cinnamon-screensaver

	l10n? ( >=gnome-extra/cinnamon-translations-2.2 )
	networkmanager? (
		gnome-extra/nm-applet
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
"
#bluetooth? ( net-wireless/cinnamon-bluetooth )

DEPEND="${COMMON_DEPEND}
	dev-python/polib[${PYTHON_USEDEP}]
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	!!=dev-lang/spidermonkey-1.8.2*
"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

S="${WORKDIR}/Cinnamon-${PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	# Fix GNOME 3.8 support
	epatch "${FILESDIR}/background.patch"

	# Fix automagic gnome-bluetooth dep, bug #398145
	epatch "${FILESDIR}/${PN}-2.2.6-automagic-gnome-bluetooth.patch"

	# Optional NetworkManager, bug #488684
	epatch "${FILESDIR}/${PN}-2.2.6-optional-networkmanager.patch"

	# Gentoo uses /usr/$(get_libdir), not /usr/lib even for python
	sed -e "s:/usr/lib/:/usr/$(get_libdir)/:" \
		-e 's:"/usr/lib":"/usr/'"$(get_libdir)"'":' \
		-i files/usr/share/polkit-1/actions/org.cinnamon.settings-users.policy \
		-i files/usr/lib/cinnamon-settings-users/cinnamon-settings-users.py \
		-i files/usr/lib/cinnamon-screensaver-lock-dialog/cinnamon-screensaver-lock-dialog.py \
		-i files/usr/lib/cinnamon-settings/cinnamon-settings.py \
		-i files/usr/lib/cinnamon-settings/modules/cs_backgrounds.py \
		-i files/usr/lib/cinnamon-settings/data/spices/applet-detail.html \
		-i files/usr/lib/cinnamon-settings/bin/*.py \
		-i files/usr/lib/cinnamon-desktop-editor/cinnamon-desktop-editor.py \
		-i files/usr/lib/cinnamon-menu-editor/cme/*.py \
		-i files/usr/bin/* || die "sed failed"
	if [[ "$(get_libdir)" != lib ]]; then
		mv files/usr/lib "files/usr/$(get_libdir)" || die "mv failed"
	fi

	if ! use networkmanager; then
		rm -rv files/usr/share/cinnamon/applets/network@cinnamon.org || die
	fi

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# Don't error out on warnings
	gnome2_src_configure \
		--disable-jhbuild-wrapper-script \
		$(use_enable networkmanager) \
		--with-ca-certificates="${EPREFIX}/etc/ssl/certs/ca-certificates.crt" \
		BROWSER_PLUGIN_DIR="${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins" \
		--without-bluetooth
		#$(use_with bluetooth)
}

src_install() {
	gnome2_src_install
	python_optimize "${ED}usr/$(get_libdir)/cinnamon-"{desktop-editor,json-makepot,launcher,looking-glass,menu-editor,screensaver-lock-dialog,settings,settings-users}
	# Fix broken shebangs
	sed -e "s%#!.*python%#!${PYTHON}%" \
		-i "${ED}usr/bin/cinnamon-"{desktop-editor,json-makepot,launcher,looking-glass,menu-editor,screensaver-lock-dialog,settings,settings-users} \
		-i "${ED}usr/$(get_libdir)/cinnamon-settings/cinnamon-settings.py" || die

	# Required for gnome-shell on hardened/PaX, bug #398941
	pax-mark mr "${ED}usr/bin/cinnamon"

	# Doesn't exist on Gentoo, causing this to be a dead symlink
	rm -f "${ED}etc/xdg/menus/cinnamon-applications-merged" || die
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of Cinnamon's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "org.cinnamon.recorder/pipeline to what you want to use."
	fi

	if ! has_version ">=x11-base/xorg-server-1.11"; then
		ewarn "If you use multiple screens, it is highly recommended that you"
		ewarn "upgrade to >=x11-base/xorg-server-1.11 to be able to make use of"
		ewarn "pointer barriers which will make it easier to use hot corners."
	fi

	if has_version "<x11-drivers/ati-drivers-12"; then
		ewarn "Cinnamon has been reported to show graphical corruption under"
		ewarn "x11-drivers/ati-drivers-11.*; you may want to switch to"
		ewarn "open-source drivers."
	fi

	if has_version "media-libs/mesa[video_cards_radeon]" ||
	   has_version "media-libs/mesa[video_cards_r300]" ||
	   has_version "media-libs/mesa[video_cards_r600]"; then
		elog "Cinnamon is unstable under classic-mode r300/r600 mesa drivers."
		elog "Make sure that gallium architecture for r300 and r600 drivers is"
		elog "selected using 'eselect mesa'."
		if ! has_version "media-libs/mesa[gallium]"; then
			ewarn "You will need to emerge media-libs/mesa with USE=gallium."
		fi
	fi
}
