# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit autotools eutils elisp-common user

MY_PV=${PV/_/-}
MY_P=TiMidity++-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A handy MIDI to WAV converter with OSS and ALSA output support"
HOMEPAGE="http://timidity.sourceforge.net/"
SRC_URI="mirror://sourceforge/timidity/${MY_P}.tar.bz2
	mirror://gentoo/${P}-patchset-2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="motif oss nas X gtk vorbis tk slang alsa jack emacs ao selinux speex flac ncurses"

DEPEND="ncurses? ( >=sys-libs/ncurses-5 )
	emacs? ( virtual/emacs )
	gtk? ( x11-libs/gtk+:2 )
	tk? ( dev-lang/tk )
	nas? ( >=media-libs/nas-1.4 )
	alsa? ( media-libs/alsa-lib )
	slang? ( sys-libs/slang )
	jack? ( media-sound/jack-audio-connection-kit )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	selinux? ( sec-policy/selinux-timidity )
	speex? ( media-libs/speex )
	ao? ( >=media-libs/libao-0.8.5 )
	motif? ( >=x11-libs/motif-2.3:0 )
	X? ( x11-libs/libXaw x11-libs/libXext >=media-libs/libpng-1.4.2 )"
RDEPEND="${DEPEND}
	alsa? ( media-sound/alsa-utils )
	app-admin/eselect-timidity"

PDEPEND="|| ( media-sound/timidity-eawpatches media-sound/timidity-freepats )"

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	enewgroup audio 18 # Just make sure it exists
	enewuser timidity -1 -1 /var/lib/timidity audio
}

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patches
	eautoreconf
}

src_configure() {
	export EXTRACFLAGS="${CFLAGS}" #385817

	local myconf
	local audios

	use flac && audios="${audios},flac"
	use speex && audios="${audios},speex"
	use vorbis && audios="${audios},vorbis"

	use oss && audios="${audios},oss"
	use jack && audios="${audios},jack"
	use ao && audios="${audios},ao"

	if use nas; then
		audios="${audios},nas"
		myconf="${myconf} --with-nas-library=/usr/$(get_libdir)/libaudio.so --with-x"
		use X || ewarn "Basic X11 support will be enabled because required by nas."
	fi

	if use alsa; then
		audios="${audios},alsa"
		myconf="${myconf} --with-default-output=alsa --enable-alsaseq"
	fi

	# We disable motif by default and then only enable it if it's requested.
	if use motif; then
		myconf="${myconf} --enable-motif --with-x"
		use X || ewarn "Basic X11 support will be enabled because required by motif."
	fi

	econf \
		--localstatedir=/var/state/timidity++ \
		--with-lispdir="${SITELISP}/${PN}" \
		--with-elf \
		--enable-audio=${audios} \
		--enable-server \
		--enable-network \
		--enable-dynamic \
		--enable-vt100 \
		--enable-spline=cubic \
		$(use_enable emacs) \
		$(use_enable slang) \
		$(use_enable ncurses) \
		$(use_with X x) \
		$(use_enable X spectrogram) \
		$(use_enable X wrd) \
		$(use_enable X xskin) \
		$(use_enable X xaw) \
		$(use_enable gtk) \
		$(use_enable tk tcltk) \
		--disable-motif \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog*
	dodoc NEWS README* "${FILESDIR}/timidity.cfg-r1"

	# these are only for the ALSA sequencer mode
	if use alsa; then
		newconfd "${FILESDIR}"/conf.d.timidity.2 timidity
		newinitd "${FILESDIR}"/init.d.timidity.4 timidity
	fi

	insinto /etc
	newins "${FILESDIR}/timidity.cfg-r1" timidity.cfg

	dodir /usr/share/timidity
	dosym /etc/timidity.cfg /usr/share/timidity/timidity.cfg

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	diropts -o timidity -g nobody -m 0700
	keepdir /var/lib/timidity

	doicon "${FILESDIR}"/timidity.xpm
	newmenu "${FILESDIR}"/timidity.desktop.2 timidity.desktop

	# Order of preference: gtk, X (Xaw), ncurses, slang
	# Do not create menu item for terminal ones
	local interface="-id"
	local terminal="true"
	local nodisplay="true"
	if use gtk || use X; then
		interface="-ia"
		terminal="false"
		nodisplay="false"
		use gtk && interface="-ig"
	elif use ncurses || use slang; then
		local interface="-is"
		use ncurses && interface="-in"
	fi
	sed -e "s/Exec=timidity/Exec=timidity ${interface}/" \
		-e "s/Terminal=.*/Terminal=${terminal}/" \
		-e "s/NoDisplay=.*/NoDisplay=${nodisplay}/" \
		-i "${D}"/usr/share/applications/timidity.desktop || die "sed failed"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "A timidity config file has been installed in /etc/timidity.cfg."
	elog "Do not edit this file as it will interfere with the eselect timidity tool."
	elog "The tool 'eselect timidity' can be used to switch between installed patchsets."

	if use alsa; then
		elog "An init script for the alsa timidity sequencer has been installed."
		elog "If you wish to use the timidity virtual sequencer, edit /etc/conf.d/timidity"
		elog "and run 'rc-update add timidity <runlevel> && /etc/init.d/timidity start'"
	fi

	if use sparc; then
		elog "Only saving to wave file and ALSA soundback has been tested working."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
