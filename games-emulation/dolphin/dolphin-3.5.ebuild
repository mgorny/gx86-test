# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

WX_GTK_VER="2.9"

inherit cmake-utils eutils flag-o-matic pax-utils toolchain-funcs versionator wxwidgets games

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"
SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa ao bluetooth doc ffmpeg +lzo openal opengl openmp portaudio pulseaudio"

RESTRICT="mirror"

RDEPEND=">=media-libs/glew-1.6
	>=media-libs/libsdl-1.2[joystick]
	<media-libs/libsfml-2.0
	sys-libs/readline
	x11-libs/libXext
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	bluetooth? ( net-wireless/bluez )
	ffmpeg? ( virtual/ffmpeg )
	lzo? ( dev-libs/lzo )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	portaudio?  ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	"
DEPEND="${RDEPEND}
	app-arch/zip
	media-gfx/nvidia-cg-toolkit
	media-libs/freetype
	>=sys-devel/gcc-4.6.0
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/wxGTK:2.9
	"

pkg_pretend() {

	local ver=4.6.0
	local msg="${PN} needs at least GCC ${ver} set to compile."

	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! version_is_at_least ${ver} $(gcc-fullversion); then
			eerror ${msg}
			die ${msg}
		fi
	fi
}

src_prepare() {

	if [[ $(gcc-version) = "4.8" ]]; then
		epatch "${FILESDIR}"/${PN}-emu-${PV}-gcc-4.8.patch
	fi

	if use !alsa; then
		sed -i -e '/^include(FindALSA/d' CMakeLists.txt || die
	fi
	if use !ao; then
		sed -i -e '/^check_lib(AO/d' CMakeLists.txt || die
	fi
	if use !bluetooth; then
		sed -i -e '/^check_lib(BLUEZ/d' CMakeLists.txt || die
	fi
	if use !openal; then
		sed -i -e '/^include(FindOpenAL/d' CMakeLists.txt || die
	fi
	if use !portaudio; then
		sed -i -e '/CMAKE_REQUIRED_LIBRARIES portaudio/d' CMakeLists.txt || die
	fi
	if use !pulseaudio; then
		sed -i -e '/^check_lib(PULSEAUDIO/d' CMakeLists.txt || die
	fi

	# Remove ALL the bundled libraries, aside from:
	# - SOIL: The sources are not public.
	# - Bochs_disasm: Don't know what it is.
	# - CLRun: Part of OpenCL
	mv Externals/SOIL . || die
	mv Externals/Bochs_disasm . || die
	mv Externals/CLRun . || die
	rm -r Externals/* || die "Failed to remove bundled libs"
	mv CLRun Externals || die
	mv Bochs_disasm Externals || die
	mv SOIL Externals || die
}

src_configure() {

	if $($(tc-getPKG_CONFIG) --exists nvidia-cg-toolkit); then
		append-flags "$($(tc-getPKG_CONFIG) --cflags nvidia-cg-toolkit)"
	else
		append-flags "-I/opt/nvidia-cg-toolkit/include"
	fi

	if $($(tc-getPKG_CONFIG) --exists nvidia-cg-toolkit); then
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-L nvidia-cg-toolkit)"
	else
		if has_version ">=media-gfx/nvidia-cg-toolkit-3.1.0013"; then
			append-ldflags "-L/opt/nvidia-cg-toolkit/lib64"
		elif has_version "<=media-gfx/nvidia-cg-toolkit-2.1.0017-r1"; then
			append-ldflags "-L/opt/nvidia-cg-toolkit/lib"
		fi
	fi

	local mycmakeargs=(
		"-DDOLPHIN_WC_REVISION=${PV}"
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-Dprefix=${GAMES_PREFIX}"
		"-Ddatadir=${GAMES_DATADIR}/${PN}"
		"-Dplugindir=$(games_get_libdir)/${PN}"
		$(cmake-utils_use ffmpeg ENCODE_FRAMEDUMPS)
		$(cmake-utils_use openmp OPENMP )
	)

	cmake-utils_src_configure
}

src_compile() {

	cmake-utils_src_compile
}

src_install() {

	cmake-utils_src_install

	dodoc Readme.txt
	if use doc; then
		dodoc -r docs/ActionReplay docs/DSP docs/WiiMote
	fi

	doicon Source/Core/DolphinWX/resources/Dolphin.xpm
	make_desktop_entry "dolphin-emu" "Dolphin" "Dolphin" "Game;"

	prepgamesdirs
}

pkg_postinst() {
	# Add pax markings for hardened systems
	pax-mark -m "${EPREFIX}"/usr/games/bin/"${PN}"-emu

	if ! use portaudio; then
		ewarn "If you want microphone capabilities in dolphin-emu, rebuild with"
		ewarn "USE=\"portaudio\""
	fi
}
