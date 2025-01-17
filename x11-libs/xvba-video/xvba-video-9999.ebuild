# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/vaapi/xvba-driver"
[[ ${PV} = 9999 ]] && inherit git-2
PYTHON_COMPAT=( python{2_6,2_7} )
AUTOTOOLS_AUTORECONF="yes"
inherit eutils autotools-multilib python-any-r1

DESCRIPTION="XVBA Backend for Video Acceleration (VA) API"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
# No source release yet, the src_uri is theoretical at best right now
[[ ${PV} = 9999 ]] || SRC_URI="http://www.freedesktop.org/software/vaapi/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ MIT"
SLOT="0"
# newline is needed for broken ekeyword
[[ ${PV} = 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl"

RDEPEND=">=x11-libs/libva-1.2.1-r1[X(+),opengl?,${MULTILIB_USEDEP}]
	>=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}]
	x11-drivers/ati-drivers"
DEPEND="${DEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( NEWS README AUTHORS )
PATCHES=(
	"${FILESDIR}"/${PN}-fix-mesa-gl.h.patch
	"${FILESDIR}"/${PN}-fix-out-of-source-builds.patch
	"${FILESDIR}"/${P}-VAEncH264VUIBufferType.patch
	"${FILESDIR}"/${P}-assert-hw_image_hooks_glx.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# bug 469208
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable opengl glx)
	)
	autotools-utils_src_configure
}
