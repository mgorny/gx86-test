# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools eutils libtool

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="http://conky.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 sparc x86"
IUSE="apcupsd audacious curl debug eve hddtemp imlib iostats lua lua-cairo lua-imlib math moc mpd nano-syntax ncurses nvidia +portmon rss thinkpad truetype vim-syntax weather-metar weather-xoap wifi X xmms2"

DEPEND_COMMON="
	X? (
		imlib? ( media-libs/imlib2[X] )
		lua-cairo? (
			>=dev-lua/toluapp-1.0.93
			>=dev-lang/lua-5.1.4-r8
			x11-libs/cairo[X] )
		lua-imlib? (
			>=dev-lua/toluapp-1.0.93
			>=dev-lang/lua-5.1.4-r8
			media-libs/imlib2[X] )
		nvidia? ( media-video/nvidia-settings )
		truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXext
		audacious? ( >=media-sound/audacious-1.5 dev-libs/glib )
		xmms2? ( media-sound/xmms2 )
	)
	curl? ( net-misc/curl )
	eve? ( net-misc/curl dev-libs/libxml2 )
	portmon? ( dev-libs/glib )
	lua? ( >=dev-lang/lua-5.1.4-r8 )
	ncurses? ( sys-libs/ncurses )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib )
	wifi? ( net-wireless/wireless-tools )
	weather-metar? ( net-misc/curl )
	weather-xoap? ( dev-libs/libxml2 net-misc/curl )
	virtual/libiconv
	"
RDEPEND="
	${DEPEND_COMMON}
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	nano-syntax? ( app-editors/nano )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	"
DEPEND="
	${DEPEND_COMMON}
	virtual/pkgconfig
	"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8.1-utf8-scroll.patch" \
		"${FILESDIR}/${P}-ncurses.patch" \
		"${FILESDIR}/${P}-lines-fix.patch" \
		"${FILESDIR}/${P}-update-when-message-count-decreases.patch" \
		"${FILESDIR}/${P}-apcupsd.patch" \
		"${FILESDIR}/${P}-default-graph-size.patch" \
		"${FILESDIR}/${P}-diskio-dmmajor.patch"

	# Allow user patches #478482
	# Only run autotools if user patched something
	epatch_user && eautoreconf || elibtoolize
}

src_configure() {
	local myconf

	if use X; then
		myconf="--enable-x11 --enable-double-buffer --enable-xdamage"
		myconf="${myconf} --enable-argb --enable-own-window"
		myconf="${myconf} $(use_enable imlib imlib2) $(use_enable lua-cairo)"
		myconf="${myconf} $(use_enable lua-imlib lua-imlib2)"
		myconf="${myconf} $(use_enable nvidia) $(use_enable truetype xft)"
		myconf="${myconf} $(use_enable audacious) $(use_enable xmms2)"
	else
		myconf="--disable-x11 --disable-own-window --disable-argb"
		myconf="${myconf} --disable-lua-cairo --disable-nvidia --disable-xft"
		myconf="${myconf} --disable-audacious --disable-xmms2"
	fi

	econf \
		${myconf} \
		$(use_enable apcupsd) \
		$(use_enable curl) \
		$(use_enable debug) \
		$(use_enable eve) \
		$(use_enable hddtemp) \
		$(use_enable iostats) \
		$(use_enable lua) \
		$(use_enable thinkpad ibm) \
		$(use_enable math) \
		$(use_enable moc) \
		$(use_enable mpd) \
		$(use_enable ncurses) \
		$(use_enable portmon) \
		$(use_enable rss) \
		$(use_enable weather-metar) \
		$(use_enable weather-xoap) \
		$(use_enable wifi wlan)
}

src_install() {
	default

	dohtml doc/*.html

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You can find sample configurations at ${ROOT%/}/etc/conky."
		elog "To customize, copy to ~/.conkyrc and edit it to your liking."
		elog
		elog "There are pretty html docs available at the conky homepage"
		elog "or in ${ROOT%/}/usr/share/doc/${PF}/html."
		elog
		elog "Also see http://www.gentoo.org/doc/en/conky-howto.xml"
		elog
	fi
}
