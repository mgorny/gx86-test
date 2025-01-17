# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit games

DESCRIPTION="A racing game starring Tux, the linux penguin"
HOMEPAGE="http://tuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/tuxkart/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 x86"
IUSE=""

RDEPEND=">=media-libs/plib-1.8.0
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXi
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_unpack() {
	unpack ${A}

	cd "${S}"
	# apparently <sys/perm.h> doesn't exist on alpha
	if use alpha; then
		sed -i \
			-e '/#include <sys\/perm.h>/d' src/gfx.cxx \
			|| die "sed src/gfx.cxx failed"
	fi
	sed -i \
		-e "/^plib_suffix/ s/-lplibul/-lplibul -lplibjs/" \
		-e "s/-malign-double//; s/-O6//" configure \
		|| die "sed configure failed"
	sed -i \
		-e "/^bindir/s/=.*/=@bindir@/" src/Makefile.in \
		|| die "sed src/Makefile.in failed"
}

src_compile() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}" || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS CHANGES README
	dohtml doc/*.html
	rm -rf "${D}/usr/share/tuxkart/"

	prepgamesdirs
}
