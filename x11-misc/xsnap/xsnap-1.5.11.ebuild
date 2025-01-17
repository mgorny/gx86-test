# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Program to interactively take a 'snapshot' of a region of the screen"
HOMEPAGE="ftp://ftp.ac-grenoble.fr/ge/Xutils/"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/Xutils/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux"
IUSE=""

COMMON_DEPEND="
	media-libs/libpng:0
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXpm
"
RDEPEND="
	${COMMON_DEPEND}
	media-fonts/font-misc-misc
"
DEPEND="
	${COMMON_DEPEND}
	app-text/rman
	dev-lang/perl
	x11-misc/imake
	x11-proto/xproto
"

DOCS=( AUTHORS Changelog README )

src_prepare() {
	sed -i \
		-e 's|/usr/share/locale|$(LOCALEDIR)|g' \
		-e 's|/usr/share/man/man1|$(MANDIR)|g' \
		-e '/cd po.*install/s|cd.*|$(MAKE) -C po LOCALEDIR=$(LOCALEDIR) install|' \
		-e '21s|.*|LOCALEDIR = /usr/share/locale|' \
		Imakefile || die
	sed -i \
		-e '/^LOCALEDIR=/d' \
		po/Makefile || die

	xmkmf || die

	sed -i \
		-e '/ CC = /d' \
		-e '/ LD = /d' \
		-e '/ CDEBUGFLAGS = /d' \
		-e '/ CCOPTIONS = /d' \
		-e 's|CPP = cpp|CPP = $(CC)|g' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake CCOPTIONS="${CFLAGS}" EXTRA_LDOPTIONS="${LDFLAGS}"
}
