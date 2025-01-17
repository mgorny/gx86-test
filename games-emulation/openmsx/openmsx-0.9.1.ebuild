# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils games

DESCRIPTION="MSX emulator that aims for perfection"
HOMEPAGE="http://openmsx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-lang/tcl
	dev-libs/libxml2
	media-libs/libpng:0
	media-libs/libsdl[sound,video]
	media-libs/glew
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	virtual/opengl"

src_prepare() {
	sed -i \
		-e '/^LDFLAGS:=/d' \
		-e '/LINK_FLAGS_PREFIX/d' \
		-e '/LINK_FLAGS+=/s/-s//' \
		-e '/LINK_FLAGS+=\$(TARGET_FLAGS)/s/$/ $(LDFLAGS)/' \
		build/main.mk \
		|| die
	sed -i -e '/SYMLINK/s:true:false:' build/custom.mk || die
	sed -i -e 's/GPL.txt//' doc/node.mk || die
}

src_compile() {
	emake \
		CXXFLAGS="${CXXFLAGS}" \
		INSTALL_SHARE_DIR="${GAMES_DATADIR}"/${PN} \
		|| die
}

src_install() {
	emake \
		INSTALL_BINARY_DIR="${D}${GAMES_BINDIR}" \
		INSTALL_SHARE_DIR="${D}${GAMES_DATADIR}"/${PN} \
		INSTALL_DOC_DIR="${D}"/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc README
	prepalldocs
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "If you want to if you want to emulate real MSX systems and not"
	elog "only the free C-BIOS machines, put the system ROMs in one of"
	elog "the following directories: ${GAMES_DATADIR}/${PN}/systemroms"
	elog "or ~/.openMSX/share/systemroms"
}
