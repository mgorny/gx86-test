# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils multilib toolchain-funcs games

DESCRIPTION="The Ur-Quan Masters: Port of Star Control 2"
HOMEPAGE="http://sc2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sc2/${P}-source.tgz
	mirror://sourceforge/sc2/${P}-content.uqm
	music? ( mirror://sourceforge/sc2/${P}-3domusic.uqm )
	voice? ( mirror://sourceforge/sc2/${P}-voice.uqm )
	remix? ( mirror://sourceforge/sc2/${PN}-remix-disc1.uqm \
		mirror://sourceforge/sc2/${PN}-remix-disc2.uqm \
		mirror://sourceforge/sc2/${PN}-remix-disc3.uqm )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="music opengl remix voice"

RDEPEND="media-libs/libmikmod
	media-libs/libogg
	>=media-libs/libpng-1.4
	media-libs/libsdl[X,sound,joystick,video]
	media-libs/libvorbis
	media-libs/sdl-image[png]
	sys-libs/zlib
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local myopengl

	use opengl \
		&& myopengl=opengl \
		|| myopengl=pure

	cat <<-EOF > config.state
	CHOICE_debug_VALUE='nodebug'
	CHOICE_graphics_VALUE='${myopengl}'
	CHOICE_sound_VALUE='mixsdl'
	CHOICE_accel_VALUE='plainc'
	INPUT_install_prefix_VALUE='${GAMES_PREFIX}'
	INPUT_install_bindir_VALUE='\$prefix/bin'
	INPUT_install_libdir_VALUE='\$prefix/lib'
	INPUT_install_sharedir_VALUE='${GAMES_DATADIR}/'
	EOF

	# Take out the read so we can be non-interactive.
	sed -i \
		-e '/read CHOICE/d' build/unix/menu_functions \
		|| die "sed menu_functions failed"

	# respect CFLAGS
	sed -i \
		-e "s/-O3//" build/unix/build.config \
		|| die "sed build.config failed"

	sed -i \
		-e "s:@INSTALL_LIBDIR@:$(games_get_libdir)/:g" build/unix/uqm-wrapper.in \
		|| die "sed uqm-wrapper.in failed"

	# respect CC
	sed -i \
		-e "s/PROG_gcc_FILE=\"gcc\"/PROG_gcc_FILE=\"$(tc-getCC)\"/" \
		build/unix/config_proginfo_build \
		|| die "sed config_proginfo_build failed"
}

src_compile() {
	MAKE_VERBOSE=1 ./build.sh uqm || die "build failed"
}

src_install() {
	# Using the included install scripts seems quite painful.
	# This manual install is totally fragile but maybe they'll
	# use a sane build system for the next release.
	newgamesbin uqm-wrapper uqm || die "newgamesbin failed"
	exeinto "$(games_get_libdir)"/${PN}
	doexe uqm || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}/content/packages
	doins "${DISTDIR}"/${P}-content.uqm || die "doins failed"
	echo ${P} > "${D}${GAMES_DATADIR}"/${PN}/content/version \
		|| die "creating version file failed"

	insinto "${GAMES_DATADIR}"/${PN}/content/addons
	if use music; then
		doins "${DISTDIR}"/${P}-3domusic.uqm || die "doins failed"
	fi

	if use voice; then
		doins "${DISTDIR}"/${P}-voice.uqm || die "doins failed"
	fi

	if use remix; then
		insinto "${GAMES_DATADIR}"/${PN}/content/addons
		doins "${DISTDIR}"/${PN}-remix-disc{1,2,3}.uqm || die "doins failed"
	fi

	dodoc AUTHORS ChangeLog Contributing README WhatsNew doc/users/manual.txt
	docinto devel
	dodoc doc/devel/[!n]*
	docinto devel/netplay
	dodoc doc/devel/netplay/*
	make_desktop_entry uqm "The Ur-Quan Masters"
	prepgamesdirs
}
