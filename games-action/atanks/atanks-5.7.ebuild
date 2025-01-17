# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils gnome2-utils games

DESCRIPTION="Worms and Scorched Earth-like game"
HOMEPAGE="http://atanks.sourceforge.net/"
SRC_URI="mirror://sourceforge/atanks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/allegro:0[X]"

src_prepare() {
	find . -type f -name ".directory" -exec rm -vf '{}' +
}

src_compile() {
	emake \
		BINDIR="${GAMES_BINDIR}" \
		INSTALLDIR="${GAMES_DATADIR}/${PN}" \
		|| die
}

src_install() {
	dogamesbin ${PN} || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r button misc missile sound stock tank tankgun text title \
		unicode.dat *.txt || die
	doicon -s 48 ${PN}.png
	make_desktop_entry atanks "Atomic Tanks"
	dodoc Changelog README TODO
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
