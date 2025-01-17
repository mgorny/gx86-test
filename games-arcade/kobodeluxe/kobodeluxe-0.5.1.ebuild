# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

MY_P="KoboDeluxe-${PV/_/}"
DESCRIPTION="An SDL port of xkobo, a addictive space shoot-em-up"
HOMEPAGE="http://www.olofson.net/kobodl/"
SRC_URI="http://www.olofson.net/kobodl/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE="opengl"

DEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	opengl? ( virtual/opengl )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./icons.tar.gz
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glibc29.patch \
		"${FILESDIR}"/${P}-glibc2.10.patch
	# Fix paths
	sed -i \
		-e 's:\$(datadir)/kobo-deluxe:$(datadir)/kobodeluxe:' \
		-e 's:\$(sharedstatedir)/kobo-deluxe/scores:$(localstatedir)/kobodeluxe:' \
		configure || die "sed configure failed"
	sed -i \
		-e 's:kobo-deluxe:kobodeluxe:' \
		data/gfx/Makefile.in \
		data/sfx/Makefile.in || die "sed data/Makefile.in failed"
}

src_configure() {
	egamesconf $(use_enable opengl) || die
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon icons/KDE/icons/32x32/kobodl.png ${PN}.png
	make_desktop_entry kobodl "Kobo Deluxe"
	dodoc ChangeLog README* TODO
	prepgamesdirs
	fperms 2775 "${GAMES_STATEDIR}"/${PN}
}
