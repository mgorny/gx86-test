# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="A package of programs that fit together to form a morse code tutor program"
HOMEPAGE="http://unixcw.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="alsa ncurses pulseaudio suid qt4"

RDEPEND="ncurses? ( sys-libs/ncurses )
	qt4? ( dev-qt/qtgui:4[qt3support] )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/libtool
	!<=app-misc/cw-1.0.16-r1"

src_prepare() {
	epatch "${FILESDIR}"/${P}-console.patch \
		"${FILESDIR}"/${P}-pulseaudio.patch

	append-cflags -std=gnu99
	# add path to qt4 libs
	sed -i -e "s#LDADD = -L#LDADD = -L/usr/$(get_libdir)/qt4 -L#g" \
		src/xcwcp/Makefile.am
	eautoreconf
}

src_configure() {
	econf --libdir=/usr/$(get_libdir) \
		$(use_enable pulseaudio ) \
		$(use_enable alsa ) \
		$(use_enable ncurses cwcp ) \
		$(use_enable qt4 xcwcp )
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
	dodoc ChangeLog NEWS README
	if ! use suid ; then
		fperms 711 /usr/bin/cw
		if use ncurses ; then
			fperms 711 /usr/bin/cwcp
		fi
		if use qt4 ; then
			fperms 711 /usr/bin/xcwcp
		fi
	fi
}

pkg_postinst() {
	if use suid ; then
		ewarn "You have choosen to install 'cw', 'cwcp' and 'xcwcp' setuid"
		ewarn "by setting USE=suid."
		ewarn "Be aware that this is a security risk and not recommended."
		ewarn ""
		ewarn "These files do only need root access if you want to use the"
		ewarn "PC speaker for morse sidetone output. You can alternativly"
		ewarn "drop USE=suid and use sudo."
	else
		elog "Be aware that 'cw', 'cwcp' and 'xcwcp' needs root access if"
		elog "you want to use the PC speaker for morse sidetone output."
		elog "You can call the programs via sudo for that (see 'man sudo')."
	fi
}
