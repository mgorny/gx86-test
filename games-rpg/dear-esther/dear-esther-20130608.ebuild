# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# TODO: unbundle libSDL2

EAPI=5

inherit eutils gnome2-utils unpacker games

TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"
DESCRIPTION="Ghost story, told using first-person gaming technologies"
HOMEPAGE="http://dear-esther.com/"
SRC_URI="dearesther-linux-${TIMESTAMP}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/dearesther_linux
	${MYGAMEDIR#/}/bin/*.so*"

DEPEND="app-arch/unzip"
RDEPEND="virtual/opengl
	amd64? (
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		media-libs/freetype
		media-libs/openal
	)"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r bin dearesther platform dearesther_linux

	doicon -s 256 dearesther.png
	make_desktop_entry "${PN}" "Dear Esther" dearesther
	games_make_wrapper ${PN} "./dearesther_linux -game dearesther" "${MYGAMEDIR}" "${MYGAMEDIR}/bin"

	dodoc README-linux.txt

	fperms +x "${MYGAMEDIR}"/dearesther_linux

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
