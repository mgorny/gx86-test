# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# NOTE!!!: to avoid masking of -9999 the
# package.mask entry for multilib version
# reads =media-libs/imlib2-1.4.6-r2
# Keep this in mind when bumping!

EAPI="4"

EGIT_SUB_PROJECT="legacy"
EGIT_URI_APPEND=${PN}

if [[ ${PV} != "9999" ]] ; then
	EKEY_STATE="snap"
fi

inherit autotools enlightenment toolchain-funcs multilib-minimal

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="http://www.enlightenment.org/"

# See bug #342185#c13
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="bzip2 gif jpeg mmx mp3 png static-libs tiff X zlib"

RDEPEND="=media-libs/freetype-2*[${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	gif? ( >=media-libs/giflib-4.1.6-r3[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:0[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	)
	mp3? ( >=media-libs/libid3tag-0.15.1b-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	png? ( >=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}] )
	X? (
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.5-no-my-libs.patch #497894
	epatch "${FILESDIR}"/${PN}-1.4.5-giflib-5.patch #457634
	epatch "${FILESDIR}"/${P}-out-of-source-build.patch #510522
	epatch "${FILESDIR}"/${P}-no-x.patch

	eautomake
}

multilib_src_configure() {
	# imlib2 has diff configure options for x86/amd64 mmx
	if [[ $(tc-arch) == amd64 ]]; then
		E_ECONF+=( $(use_enable mmx amd64) --disable-mmx )
	else
		E_ECONF+=( --disable-amd64 $(use_enable mmx) )
	fi

	[[ $(gcc-major-version) -ge 4 ]] && E_ECONF+=( --enable-visibility-hiding )

	ECONF_SOURCE="${S}" \
	E_ECONF+=(
		$(use_enable static-libs static)
		$(use_with X x)
		$(use_with jpeg)
		$(use_with png)
		$(use_with tiff)
		$(use_with gif)
		$(use_with zlib)
		$(use_with bzip2)
		$(use_with mp3 id3)
	)

	enlightenment_src_configure
}

multilib_src_install() {
	enlightenment_src_install
}
