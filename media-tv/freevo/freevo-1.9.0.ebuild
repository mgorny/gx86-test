# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"

inherit distutils eutils

DESCRIPTION="Digital video jukebox (PVR, DVR)"
HOMEPAGE="http://www.freevo.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="directfb cdparanoia doc dvd encode fbcon flac gphoto2 jpeg lame lirc matrox mixer nls tv vorbis xine X"

RDEPEND="dev-python/beautifulsoup:python-2
	virtual/python-imaging
	dev-python/pygame
	>=dev-python/twisted-core-2.5
	>=dev-python/twisted-web-0.6
	net-zope/zope-interface

	>=dev-python/kaa-base-0.6.0
	>=dev-python/kaa-metadata-0.7.3
	>=dev-python/kaa-imlib2-0.2.3
	dev-python/kaa-display

	media-video/mplayer[directfb?,fbcon?]
	>=media-libs/libsdl-1.2.5[directfb?,fbcon?]
	media-libs/sdl-image[jpeg,png]
	x11-apps/xset

	cdparanoia? ( media-sound/cdparanoia )
	dvd? (
		>=media-video/lsdvd-0.10
		directfb? ( media-libs/xine-lib[directfb] )
		fbcon? ( media-libs/xine-lib[fbcon] )
		encode? ( media-video/dvdbackup )
	)
	flac? ( media-libs/flac )
	gphoto2? ( media-libs/libgphoto2 )
	jpeg? ( virtual/jpeg )
	lame? ( media-sound/lame )
	lirc? ( app-misc/lirc >=dev-python/pylirc-0.0.3 )
	matrox? ( >=media-video/matroxset-0.3 )
	mixer? ( media-sound/aumix )
	tv? ( media-tv/xmltv )
	xine? ( media-video/xine-ui )
	vorbis? ( media-sound/vorbis-tools )"

pkg_setup() {
	if ! { use X || use directfb || use fbcon || use matrox ; } ; then
		echo
		ewarn "WARNING - no video support specified in USE flags."
		ewarn "Please be sure that media-libs/libsdl supports whatever video"
		ewarn "support (X11, fbcon, directfb, etc) you plan on using."
		echo
	fi

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-PIL.patch

	distutils_src_prepare
	python_convert_shebangs -r 2 .
}

src_install() {
	distutils_src_install

	insinto /etc/freevo
	newins local_conf.py.example local_conf.py

	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		sed -i -e "s/# MPLAYER_AO_DEV.*/MPLAYER_AO_DEV='alsa1x'/" "${D}"/etc/freevo/local_conf.py
		newins "${FILESDIR}"/xbox-lircrc lircrc
	fi

	if use X; then
		echo "#!/bin/bash" > freevo
		echo "/usr/bin/freevoboot startx" >> freevo
		exeinto /etc/X11/Sessions/
		doexe freevo

		#insinto /etc/X11/dm/Sessions
		#doins "${FILESDIR}/freevo.desktop"

		insinto /usr/share/xsessions
		doins "${FILESDIR}/freevo.desktop"
	fi

	exeinto /usr/bin
	newexe "${FILESDIR}"/${PN}-1.8.2.boot freevoboot
	newconfd "${FILESDIR}/freevo.conf" freevo

	rm -rf "${D}/usr/share/doc"

	dodoc ChangeLog FAQ RELEASE_NOTES README TODO \
		Docs/{CREDITS,NOTES,*.txt,plugins/*.txt}
	use doc &&
		cp -r Docs/{installation,html,plugin_writing} "${D}/usr/share/doc/${PF}"

	use nls || rm -rf "${D}"/usr/share/locale

	# Create a default freevo setup
	cd "${S}/src"
	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		myconf="${myconf} --geometry=640x480 --display=x11"
	elif use matrox && use directfb; then
		myconf="${myconf} --geometry=768x576 --display=dfbmga"
	elif use matrox ; then
		myconf="${myconf} --geometry=768x576 --display=mga"
	elif use directfb; then
		myconf="${myconf} --geometry=768x576 --display=directfb"
	elif use X ; then
		myconf="${myconf} --geometry=800x600 --display=x11"
	else
		myconf="${myconf} --geometry=800x600 --display=fbdev"
	fi
	sed -i "s:/etc/freevo/freevo.conf:${D}/etc/freevo/freevo.conf:g" setup_freevo.py || die "Could not fix setup_freevo.py"
	"$(PYTHON)" setup_freevo.py ${myconf} || die "Could not create new freevo.conf"
}

pkg_postinst() {
	distutils_pkg_postinst

	echo
	einfo "Please check /etc/freevo/freevo.conf and"
	einfo "/etc/freevo/local_conf.py before starting Freevo."
	einfo "To rebuild freevo.conf with different parameters,"
	einfo "please run:"
	einfo "  # freevo setup"

	ewarn "To update from existing installations, please run"
	ewarn "  # freevo convert_config /etc/freevo/local_conf.py -w"
	ewarn "If you are using the recordserver, be sure to"
	ewarn "read the RELEASE_NOTES in /usr/share/doc/${P}"

	echo
	einfo "To build a freevo-only system, please use the freevoboot"
	einfo "wrapper to be run it as a user. It can be configured in /etc/conf.d/freevo"

	if use X ; then
		echo
		ewarn "If you're using a Freevo-only system with X, you'll need"
		ewarn "to setup the autologin (as user) and choose freevo as"
		ewarn "default session. If you need to run recordserver/webserver"
		ewarn "at boot, please use /etc/conf.d/freevo"
		echo
		ewarn "Should you decide to personalize your freevo.desktop"
		ewarn "session, keep the definition for '/usr/bin/freevoboot startx'"
	else
		echo
		ewarn "If you want Freevo to start automatically,you'll need"
		ewarn "to follow instructions at :"
		ewarn "http://doc.freevo.org/BootFreevo"
		echo
		ewarn "*NOTE: you can use mingetty or provide a login"
		ewarn "program for getty to autologin as a user with limited privileges."
		ewarn "A tutorial for getty is at:"
		ewarn "http://ubuntuforums.org/showthread.php?t=152274"
	fi

	if [ -e "${ROOT}/etc/init.d/freevo" ] ; then
		echo
		ewarn "Please remove /etc/init.d/freevo as it is a security"
		ewarn "threat. To set autostart read above."
	fi

	if [ -e "${ROOT}/opt/freevo" ] ; then
		echo
		ewarn "Please remove ${ROOT}/opt/freevo because it is no longer used."
	fi
	if [ -e "${ROOT}/etc/freevo/freevo_config.py" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/freevo/freevo_config.py."
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-record" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-record"
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-web" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-web"
	fi
}
