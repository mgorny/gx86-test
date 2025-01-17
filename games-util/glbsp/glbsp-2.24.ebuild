# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils toolchain-funcs versionator

MY_PV=$(delete_version_separator 1)
DESCRIPTION="A node builder specially designed for OpenGL ports of the DOOM game engine"
HOMEPAGE="http://glbsp.sourceforge.net/"
SRC_URI="mirror://sourceforge/glbsp/${PN}_src_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="fltk"

DEPEND="fltk? ( x11-libs/fltk:1 )"

S=${WORKDIR}/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "/^CC=/s:=.*:=$(tc-getCC):" \
		-e "/^CXX=/s:=.*:=$(tc-getCXX):" \
		-e "/^AR=/s:ar:$(tc-getAR):" \
		-e "/^RANLIB=/s:=.*:=$(tc-getRANLIB):" \
		-e "s:-O2:${CFLAGS}:" \
		-e "s:-O -g3:${CFLAGS}:" \
		Makefile.unx \
		nodeview/Makefile.unx \
		|| die "sed failed"
}

src_compile() {
	emake -f Makefile.unx || die "emake failed"
	if use fltk ; then
		emake -f Makefile.unx glBSPX \
			FLTK_FLAGS="$(fltk-config --cflags)" \
			FLTK_LIBS="$(fltk-config --use-images --ldflags)" \
			|| die "emake failed"
		emake -f Makefile.unx -C nodeview \
			FLTK_CFLAGS="$(fltk-config --cflags)" \
			FLTK_LIBS="$(fltk-config --use-images --ldflags)" \
			|| die "emake failed"
	fi
}

src_install() {
	dobin glbsp || die "dobin failed"
	dolib.a libglbsp.a || die "dolib.a failed"
	doman glbsp.1
	dodoc AUTHORS.txt glbsp.txt
	insinto "/usr/include"
	doins "src/glbsp.h" || die "doins failed"

	if use fltk ; then
		newbin glBSPX glbspx || die "newbin failed"
		newicon gui/icon.xpm glbspx.xpm
		make_desktop_entry glbspx glBSPX glbspx

		dobin nodeview/nodeview || die "dobin failed"
		docinto nodeview
		dodoc nodeview/{README,TODO}.txt || die "dodoc failed"
	fi
}
