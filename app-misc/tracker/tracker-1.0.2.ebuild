# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )
VALA_MIN_API_VERSION="0.14"

inherit autotools eutils gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="cue eds elibc_glibc exif ffmpeg firefox-bookmarks flac gif gsf
gstreamer gtk iptc +iso +jpeg +miner-fs mp3 nautilus networkmanager
pdf playlist rss test thunderbird +tiff upnp-av upower +vorbis +xml xmp xps"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	cue? ( gstreamer )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !gsf !iptc !iso !jpeg !mp3 !pdf !playlist !tiff !vorbis !xml !xmp !xps )
"

# According to NEWS, introspection is non-optional
# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
# sqlite-3.7.16 for FTS4 support
RDEPEND="
	>=app-i18n/enca-1.9
	>=dev-db/sqlite-3.7.16:=
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-0.9.5
	>=dev-libs/icu-4.8.1.1:=
	|| (
		>=media-gfx/imagemagick-5.2.1[png,jpeg=]
		media-gfx/graphicsmagick[imagemagick,png,jpeg=] )
	>=media-libs/libpng-1.2:0=
	>=media-libs/libmediaart-0.1:1.0
	>=x11-libs/pango-1:=
	sys-apps/util-linux

	cue? ( media-libs/libcue )
	eds? (
		>=mail-client/evolution-3.3.5:=
		>=gnome-extra/evolution-data-server-3.3.5:=
		<mail-client/evolution-3.5.3
		<gnome-extra/evolution-data-server-3.5.3 )
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? ( >=virtual/ffmpeg-9 )
	firefox-bookmarks? ( || (
		>=www-client/firefox-4.0
		>=www-client/firefox-bin-4.0 ) )
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib )
	gsf? ( >=gnome-extra/libgsf-1.14.24 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	gtk? (
		>=dev-libs/libgee-0.3:0.8
		>=x11-libs/gtk+-3:3 )
	iptc? ( media-libs/libiptcdata )
	iso? ( >=sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( >=media-libs/taglib-1.6 )
	networkmanager? ( >=net-misc/networkmanager-0.8 )
	pdf? (
		>=x11-libs/cairo-1:=
		>=app-text/poppler-0.16:=[cairo,utils]
		>=x11-libs/gtk+-2.12:2 )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	rss? ( net-libs/libgrss:0.5 )
	thunderbird? ( || (
		>=mail-client/thunderbird-5.0
		>=mail-client/thunderbird-bin-5.0 ) )
	tiff? ( media-libs/tiff )
	upnp-av? ( >=media-libs/gupnp-dlna-0.9.4:2.0 )
	vorbis? ( >=media-libs/libvorbis-0.22 )
	xml? ( >=dev-libs/libxml2-2.6 )
	xmp? ( >=media-libs/exempi-2.1 )
	xps? ( app-text/libgxps )
	!gstreamer? ( !ffmpeg? ( || ( media-video/totem media-video/mplayer ) ) )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	gtk? ( >=dev-libs/libgee-0.3 )
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"
PDEPEND="nautilus? ( ~gnome-extra/nautilus-tracker-tags-${PV} )"

# configure mixes enable-compile-warnings and with-compile-warnings
# See upstream bug #705315
QA_CONFIGURE_OPTIONS="--enable-compile-warnings"

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	# Don't run 'firefox --version' or 'thunderbird --version'; it results in
	# access violations on some setups (bug #385347, #385495).
	create_version_script "www-client/firefox" "Mozilla Firefox" firefox-version.sh
	create_version_script "mail-client/thunderbird" "Mozilla Thunderbird" thunderbird-version.sh

	# Skip broken tests
	# https://bugzilla.gnome.org/show_bug.cgi?id=699408
	sed -e '\%/libtracker-common/file-utils/has_write_access_or_was_created%,+1 d' \
		-i tests/libtracker-common/tracker-file-utils-test.c || die
	# Fails inside portage, not outside
	# https://bugzilla.gnome.org/show_bug.cgi?id=699413
	sed -e '\%/steroids/tracker/tracker_sparql_update_async%,+3 d' \
		-i tests/tracker-steroids/tracker-test.c || die

	eautoreconf # See bug #367975
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myconf=""

	if use gstreamer ; then
		myconf="${myconf} --enable-generic-media-extractor=gstreamer"
		if use upnp-av; then
			myconf="${myconf} --with-gstreamer-backend=gupnp-dlna"
		else
			myconf="${myconf} --with-gstreamer-backend=discoverer"
		fi
	elif use ffmpeg ; then
		myconf="${myconf} --enable-generic-media-extractor=libav"
	else
		myconf="${myconf} --enable-generic-media-extractor=external"
	fi

	# unicode-support: libunistring, libicu or glib ?
	# According to NEWS, introspection is required
	# is not being generated
	# nautilus extension is in a separate package, nautilus-tracker-tags
	gnome2_src_configure \
		--disable-hal \
		--disable-nautilus-extension \
		--enable-abiword \
		--enable-artwork \
		--enable-dvi \
		--enable-icon \
		--enable-ps \
		--enable-text \
		--enable-guarantee-metadata \
		--enable-introspection \
		--enable-libpng \
		--enable-libmediaart \
		--enable-tracker-fts \
		--enable-enca \
		--with-unicode-support=libicu \
		$(use_enable cue libcue) \
		$(use_enable eds miner-evolution) \
		$(use_enable exif libexif) \
		$(use_enable firefox-bookmarks miner-firefox) \
		$(use_with firefox-bookmarks firefox-plugin-dir "${EPREFIX}"/usr/$(get_libdir)/firefox/extensions) \
		FIREFOX="${S}"/firefox-version.sh \
		$(use_enable flac libflac) \
		$(use_enable gif libgif) \
		$(use_enable gsf libgsf) \
		$(use_enable gtk tracker-needle) \
		$(use_enable gtk tracker-preferences) \
		$(use_enable iptc libiptcdata) \
		$(use_enable iso libosinfo) \
		$(use_enable jpeg libjpeg) \
		$(use_enable upower upower) \
		$(use_enable miner-fs) \
		$(use_enable mp3 taglib) \
		$(use_enable mp3) \
		$(use_enable networkmanager network-manager) \
		$(use_enable pdf poppler) \
		$(use_enable playlist) \
		$(use_enable rss miner-rss) \
		$(use_enable test functional-tests) \
		$(use_enable test unit-tests) \
		$(use_enable thunderbird miner-thunderbird) \
		$(use_with thunderbird thunderbird-plugin-dir "${EPREFIX}"/usr/$(get_libdir)/thunderbird/extensions) \
		THUNDERBIRD="${S}"/thunderbird-version.sh \
		$(use_enable tiff libtiff) \
		$(use_enable vorbis libvorbis) \
		$(use_enable xml libxml2) \
		$(use_enable xmp exempi) \
		$(use_enable xps libgxps) \
		${myconf}
}

src_test() {
	export G_MESSAGES_DEBUG=all # upstream bug #699401#c1
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}

src_install() {
	gnome2_src_install

	# Manually symlink extensions for {firefox,thunderbird}-bin
	if use firefox-bookmarks; then
		dosym /usr/share/xul-ext/trackerfox \
			/usr/$(get_libdir)/firefox-bin/extensions/trackerfox@bustany.org
	fi

	if use thunderbird; then
		dosym /usr/share/xul-ext/trackerbird \
			/usr/$(get_libdir)/thunderbird-bin/extensions/trackerbird@bustany.org
	fi
}

create_version_script() {
	# Create script $3 that prints "$2 MAX(VERSION($1), VERSION($1-bin))"

	local v=$(best_version ${1})
	v=${v#${1}-}
	local vbin=$(best_version ${1}-bin)
	vbin=${vbin#${1}-bin-}

	if [[ -z ${v} ]]; then
		v=${vbin}
	else
		version_compare ${v} ${vbin}
		[[ $? -eq 1 ]] && v=${vbin}
	fi

	echo -e "#!/bin/sh\necho $2 $v" > "$3" || die
	chmod +x "$3" || die
}
