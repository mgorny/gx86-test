# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit flag-o-matic multilib toolchain-funcs eutils multilib-minimal

DESCRIPTION="A free library for encoding X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
else
	inherit versionator
	MY_P="x264-snapshot-$(get_version_component_range 3)-2245"
	SRC_URI="http://download.videolan.org/pub/videolan/x264/snapshots/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
	S="${WORKDIR}/${MY_P}"
fi

SONAME="135"
SLOT="0/${SONAME}"

LICENSE="GPL-2"
IUSE="10bit +interlaced pic static-libs sse +threads"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="abi_x86_32? ( ${ASM_DEP} )
	abi_x86_64? ( ${ASM_DEP} )"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r7
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

DOCS="AUTHORS doc/*.txt"

src_prepare() {
	# Initial support for x32 ABI, bug #420241
	# Avoid messing too much with CFLAGS.
	epatch "${FILESDIR}"/${P}-cflags.patch
}

multilib_src_configure() {
	tc-export CC
	local asm_conf=""

	if [[ ${ABI} == x86* ]] && use pic || [[ ${ABI} == "x32" ]]; then
		asm_conf=" --disable-asm"
	fi

	# Upstream uses this, see the cflags patch
	use sse && append-flags "-msse" "-mfpmath=sse"

	"${S}/configure" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-cli \
		--disable-avs \
		--disable-lavf \
		--disable-swscale \
		--disable-ffms \
		--disable-gpac \
		--enable-pic \
		--enable-shared \
		--host="${CHOST}" \
		$(usex 10bit "--bit-depth=10" "") \
		$(usex interlaced "" "--disable-interlaced") \
		--disable-opencl \
		$(usex static-libs "--enable-static" "") \
		$(usex threads "" "--disable-thread") \
		${asm_conf} || die
}
