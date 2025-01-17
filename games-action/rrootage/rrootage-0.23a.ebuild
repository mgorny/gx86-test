# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

MY_PN="rRootage"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Abstract shooter - defeat auto-created huge battleships"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/rr_e.html
	http://rrootage.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	>=dev-libs/libbulletml-0.0.3"

S=${WORKDIR}/${MY_PN}/src

src_prepare() {
	epatch "${FILESDIR}/${P}"-gcc41.patch
	sed \
		-e "s/-lglut/-lGL -lGLU -lm/" \
		-e "/^CC/d" \
		-e "/^CXX/d" \
		-e "/^LDFLAGS/s/=/+=/" \
		-e "/^CPPFLAGS/s/MORE_CFLAGS/MORE_CXXFLAGS/" \
		-e "/^CPPFLAGS/s/MORE_CFLAGS/MORE_CXXFLAGS/" \
		-e "s/ -mwindows//" \
		-e "s:-I./bulletml/:-I/usr/include/bulletml:" \
		makefile.lin > Makefile || die "sed failed"

	sed -i \
		-e "s:/usr/share/games:${GAMES_DATADIR}:" \
		barragemanager.cc screen.c soundmanager.c \
		|| die "sed failed"
}

src_compile() {
	emake \
		MORE_CFLAGS="-DLINUX ${CFLAGS}" \
		MORE_CXXFLAGS="-DLINUX ${CXXFLAGS}" \
		|| die "emake failed"
}

src_install() {
	newgamesbin rr ${PN} || die "newgamesbin failed"
	dodir "${GAMES_DATADIR}/${MY_PN}"
	cp -r ../rr_share/* "${D}/${GAMES_DATADIR}/${MY_PN}" || die "cp failed"
	dodoc ../readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! has_version "media-libs/sdl-mixer[vorbis]" ; then
		elog "${PN} will not have sound since sdl-mixer"
		elog "is built with USE=-vorbis"
		elog "Please emerge sdl-mixer with USE=vorbis"
		elog "if you want sound support"
	fi
}
