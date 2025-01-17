# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit eutils flag-o-matic multilib udev user toolchain-funcs

# gphoto and v4l are handled by their usual USE flags.
# The pint backend was disabled because I could not get it to compile.
IUSE_SANE_BACKENDS="
	abaton
	agfafocus
	apple
	artec
	artec_eplus48u
	as6e
	avision
	bh
	canon
	canon630u
	canon_dr
	canon_pp
	cardscan
	coolscan
	coolscan2
	coolscan3
	dc210
	dc240
	dc25
	dell1600n_net
	dmc
	epjitsu
	epson
	epson2
	fujitsu
	genesys
	gt68xx
	hp
	hp3500
	hp3900
	hp4200
	hp5400
	hp5590
	hpljm1005
	hpsj5s
	hs2p
	ibm
	kodak
	kodakaio
	kvs1025
	kvs20xx
	kvs40xx
	leo
	lexmark
	ma1509
	magicolor
	matsushita
	microtek
	microtek2
	mustek
	mustek_pp
	mustek_usb
	mustek_usb2
	nec
	net
	niash
	p5
	pie
	pixma
	plustek
	plustek_pp
	pnm
	qcam
	ricoh
	rts8891
	s9036
	sceptre
	sharp
	sm3600
	sm3840
	snapscan
	sp15c
	st400
	stv680
	tamarack
	teco1
	teco2
	teco3
	test
	u12
	umax
	umax1220u
	umax_pp
	xerox_mfp"

IUSE="avahi doc gphoto2 ipv6 threads usb v4l xinetd"

for backend in ${IUSE_SANE_BACKENDS}; do
	if [ ${backend} = pnm ]; then
		IUSE="${IUSE} -sane_backends_pnm"
	elif [ ${backend} = mustek_usb2 -o ${backend} = kvs40xx ]; then
		IUSE="${IUSE} sane_backends_${backend}"
	else
		IUSE="${IUSE} +sane_backends_${backend}"
	fi
done

REQUIRED_USE="
	sane_backends_mustek_usb2? ( threads )
	sane_backends_kvs40xx? ( threads )
"

DESCRIPTION="Scanner Access Now Easy - Backends"
HOMEPAGE="http://www.sane-project.org/"

RDEPEND="
	sane_backends_dc210? ( virtual/jpeg )
	sane_backends_dc240? ( virtual/jpeg )
	sane_backends_dell1600n_net? ( virtual/jpeg
									media-libs/tiff )
	avahi? ( >=net-dns/avahi-0.6.24 )
	sane_backends_canon_pp? ( sys-libs/libieee1284 )
	sane_backends_hpsj5s? ( sys-libs/libieee1284 )
	sane_backends_mustek_pp? ( sys-libs/libieee1284 )
	usb? ( virtual/libusb:0 )
	gphoto2? (
		media-libs/libgphoto2:=
		virtual/jpeg
	)
	v4l? ( media-libs/libv4l )
	xinetd? ( sys-apps/xinetd )"

DEPEND="${RDEPEND}
	v4l? ( sys-kernel/linux-headers )
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)
	>=sys-apps/sed-4

	virtual/pkgconfig"

# We now use new syntax construct (SUBSYSTEMS!="usb|usb_device)
RDEPEND="${RDEPEND}
	!<sys-fs/udev-114"

SRC_URI="https://alioth.debian.org/frs/download.php/3752/sane-backends-1.0.23.tar.gz.1
	https://alioth.debian.org/frs/download.php/3753/sane-backends-1.0.23.tar.gz.2
	https://alioth.debian.org/frs/download.php/3754/sane-backends-1.0.23.tar.gz.3"
SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"

pkg_setup() {
	enewgroup scanner
	enewuser saned -1 -1 -1 scanner
}

src_unpack() {
	rm -f "${P}.tar.gz"
	for file in ${A}; do
		cat "${DISTDIR}/${file}" >> "${P}.tar.gz"
	done
	tar xzf "${P}.tar.gz"
}

src_prepare() {
	cat >> backend/dll.conf.in <<-EOF
	# Add support for the HP-specific backend.  Needs net-print/hplip installed.
	hpaio
	# Add support for the Epson-specific backend.  Needs media-gfx/iscan installed.
	epkowa
	EOF
	epatch "${FILESDIR}"/niash_array_index.patch

}

src_configure() {
	append-flags -fno-strict-aliasing

	# the blank is intended - an empty string would result in building ALL backends.
	local BACKENDS=" "

	use gphoto2 && BACKENDS="gphoto2"
	use v4l && BACKENDS="${BACKENDS} v4l"
	for backend in ${IUSE_SANE_BACKENDS}; do
		if use "sane_backends_${backend}" && [ ${backend} != pnm ]; then
			BACKENDS="${BACKENDS} ${backend}"
		fi
	done

	local myconf=$(use_enable usb libusb)
	# you can only enable this backend, not disable it...
	if use sane_backends_pnm; then
		myconf="${myconf} --enable-pnm-backend"
	fi
	if ! use doc; then
		myconf="${myconf} --disable-latex"
	fi
	if use sane_backends_mustek_pp; then
		myconf="${myconf} --enable-parport-directio"
	fi
	if ! ( use sane_backends_canon_pp || use sane_backends_hpsj5s || use sane_backends_mustek_pp ); then
		myconf="${myconf} sane_cv_use_libieee1284=no"
	fi
	# if LINGUAS is set, just use the listed and supported localizations.
	if [ "${LINGUAS-NoLocalesSet}" != NoLocalesSet ]; then
		echo > po/LINGUAS
		for lang in ${LINGUAS}; do
			if [ -a po/${lang}.po ]; then
				echo ${lang} >> po/LINGUAS
			fi
		done
	fi
	SANEI_JPEG="sanei_jpeg.o" SANEI_JPEG_LO="sanei_jpeg.lo" \
	BACKENDS="${BACKENDS}" econf \
		$(use_with gphoto2) \
		$(use_enable avahi) \
		$(use_enable ipv6) \
		$(use_enable threads pthread) \
		${myconf}
}

src_compile() {
	emake VARTEXFONTS="${T}/fonts" || die

	if use usb; then
		cd tools/hotplug
		grep -v '^$' libsane.usermap > libsane.usermap.new
		mv libsane.usermap.new libsane.usermap
	fi

	if tc-is-cross-compiler; then
		# The build system sucks and doesn't handle this properly.
		# https://alioth.debian.org/tracker/index.php?func=detail&aid=314236&group_id=30186&atid=410366
		tc-export_build_env BUILD_CC
		cd "${S}"/tools
		${BUILD_CC} ${BUILD_CPPFLAGS} ${BUILD_CFLAGS} -I. -I../include \
			../sanei/sanei_config.c ../sanei/sanei_constrain_value.c \
			../sanei/sanei_init_debug.c sane-desc.c -o sane-desc || die
		local dirs=( hal hotplug hotplug-ng udev )
		local targets=(
			hal/libsane.fdi
			hotplug/libsane.usermap
			hotplug-ng/libsane.db
			udev/libsane.rules
		)
		mkdir -p "${dirs[@]}" || die
		emake "${targets[@]}"
	fi
}

src_install () {
	emake INSTALL_LOCKPATH="" DESTDIR="${D}" install \
		docdir="${EPREFIX}"/usr/share/doc/${PF} || die
	keepdir /var/lib/lock/sane
	fowners root:scanner /var/lib/lock/sane
	fperms g+w /var/lib/lock/sane
	dodir /etc/env.d

	if use usb; then
		insinto /etc/hotplug/usb
		exeinto /etc/hotplug/usb
		doins tools/hotplug/libsane.usermap
		doexe tools/hotplug/libusbscanner
		newdoc tools/hotplug/README README.hotplug
	fi
	udev_newrules tools/udev/libsane.rules 41-libsane.rules
	insinto "/usr/share/pkgconfig"
	doins tools/sane-backends.pc

	dodoc NEWS AUTHORS ChangeLog* PROBLEMS README README.linux
	find "${ED}" -name "*.la" | while read file; do rm "${file}"; done
	if use xinetd; then
		insinto /etc/xinetd.d
		doins "${FILESDIR}"/saned
	fi
}

pkg_postinst() {
	if use xinetd; then
		elog "If you want remote clients to connect, edit"
		elog "/etc/sane.d/saned.conf and /etc/hosts.allow"
		elog "If you are using an USB scanner, add the saned user"
		elog "to the usb group."
	fi
}
