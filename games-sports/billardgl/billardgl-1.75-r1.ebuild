# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="an OpenGL billards game"
HOMEPAGE="http://www.billardgl.de/"
SRC_URI="mirror://sourceforge/${PN}/BillardGL-${PV}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libXi
	x11-libs/libXmu
	virtual/opengl
	virtual/glu
	media-libs/freeglut"

S=${WORKDIR}/BillardGL-${PV}/src

src_prepare() {
	sed -i \
		-e "s:/usr/share/BillardGL/:${GAMES_DATADIR}/${PN}/:" \
		Namen.h \
		|| die "sed Namen.h failed"
	sed -i \
		-e '/^LINK/s:g++:$(CXX):' \
		-e '/^CXX[[:space:]]/d' \
		-e '/^CC[[:space:]]/d' \
		-e '/^CXXFLAGS/s:=.*\(-D.*\)-.*:+=\1:' \
		-e "/^LFLAGS/s:=:=${LDFLAGS}:" \
		Makefile \
		|| die "sed Makefile failed"
	sed -i \
		-e 's:<iostream.h>:<iostream>:' \
		-e 's:<fstream.h>:<fstream>\nusing namespace std;:' \
		bmp.cpp \
		|| die "sed bmp.cpp failed"
}

src_install() {
	newgamesbin BillardGL ${PN} || die "newgamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r lang Texturen || die "doins failed"
	dodoc README
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} BillardGL
	prepgamesdirs
}
