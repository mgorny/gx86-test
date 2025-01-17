# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit cmake-multilib

MY_P=${PN}-soft-${PV}

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="http://kcat.strangesoft.net/openal.html"
SRC_URI="http://kcat.strangesoft.net/openal-releases/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="alsa alstream coreaudio debug neon oss portaudio pulseaudio sse"

RDEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	alstream? ( virtual/ffmpeg )
	portaudio? ( >=media-libs/portaudio-19_pre[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-sdl-20131008-r1
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

S=${WORKDIR}/${MY_P}

DOCS="alsoftrc.sample env-vars.txt hrtf.txt README"

src_configure() {
	my_configure() {
		local mycmakeargs=(
			$(cmake-utils_use alsa)
			$(cmake-utils_use coreaudio)
			$(cmake-utils_use neon)
			$(cmake-utils_use oss)
			$(cmake-utils_use portaudio)
			$(cmake-utils_use pulseaudio)
			$(cmake-utils_use sse)
		)

		if multilib_is_native_abi; then
			mycmakeargs+=( $(cmake-utils_use alstream EXAMPLES) )
		else
			mycmakeargs+=( "-DEXAMPLES=OFF" )
		fi

		cmake-utils_src_configure
	}

	multilib_parallel_foreach_abi my_configure
}
