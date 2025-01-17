# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils multilib-minimal

MY_P=${P/sdl-/SDL_}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_mixer/"
SRC_URI="http://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="flac fluidsynth mad midi mikmod mod modplug mp3 playtools smpeg static-libs timidity vorbis +wav"
REQUIRED_USE="
	midi? ( || ( timidity fluidsynth ) )
	timidity? ( midi )
	fluidsynth? ( midi )
	mp3? ( || ( smpeg mad ) )
	smpeg? ( mp3 )
	mad? ( mp3 )
	mod? ( || ( mikmod modplug ) )
	mikmod? ( mod )
	modplug? ( mod )
	"

RDEPEND=">=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	midi? (
		fluidsynth? ( >=media-sound/fluidsynth-1.1.6-r1[${MULTILIB_USEDEP}] )
		timidity? ( media-sound/timidity++ )
	)
	mp3? (
		mad? ( >=media-libs/libmad-0.15.1b-r8[${MULTILIB_USEDEP}] )
		smpeg? ( >=media-libs/smpeg-0.4.4-r10[${MULTILIB_USEDEP}] )
	)
	mod? (
		modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
		mikmod? ( >=media-libs/libmikmod-3.2.0[${MULTILIB_USEDEP}] )
	)
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-sdl-20140406-r1
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
	)"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-wav.patch \
		"${FILESDIR}"/${P}-clang.patch \
		"${FILESDIR}"/${P}-Fix-compiling-against-libmodplug-0.8.8.5.patch \
		"${FILESDIR}"/${P}-mikmod-r58{7,8}.patch #445980
	sed -i \
		-e '/link.*play/s/-o/$(LDFLAGS) -o/' \
		Makefile.in || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-dependency-tracking \
		--disable-music-flac-shared \
		--disable-music-fluidsynth-shared \
		--disable-music-mod-shared \
		--disable-music-mp3-shared \
		--disable-music-ogg-shared \
		$(use_enable wav music-wave) \
		$(use_enable vorbis music-ogg) \
		$(use_enable mikmod music-mod) \
		$(use_enable modplug music-mod-modplug) \
		$(use_enable flac music-flac) \
		$(use_enable static-libs static) \
		$(use_enable smpeg music-mp3) \
		$(use_enable mad music-mp3-mad-gpl) \
		$(use_enable timidity music-timidity-midi) \
		$(use_enable fluidsynth music-fluidsynth-midi)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if multilib_is_native_abi && use playtools; then
		emake DESTDIR="${D}" install-bin
	fi
}

multilib_src_install_all() {
	dodoc CHANGES README
	if ! use static-libs ; then
		prune_libtool_files --all
	fi
}

pkg_postinst() {
	# bug 412035
	# https://bugs.gentoo.org/show_bug.cgi?id=412035
	if use midi ; then
		if use fluidsynth; then
			ewarn "FluidSynth support requires you to set the SDL_SOUNDFONTS"
			ewarn "environment variable to the location of a SoundFont file"
			ewarn "unless the game or application happens to do this for you."

			if use timidity; then
				ewarn "Failing to do so will result in Timidity being used instead."
			else
				ewarn "Failing to do so will result in silence."
			fi
		fi
	fi
}
