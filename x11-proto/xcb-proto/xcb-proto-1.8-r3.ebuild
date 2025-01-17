# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
XORG_MULTILIB=yes

inherit python-r1 xorg-2

DESCRIPTION="X C-language Bindings protocol headers"
HOMEPAGE="http://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/proto"
[[ ${PV} != 9999* ]] && \
	SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/libxml2"

src_configure() {
	python_export_best
	xorg-2_src_configure
}

multilib_src_configure() {
	autotools-utils_src_configure

	if multilib_is_native_abi; then
		python_parallel_foreach_impl autotools-utils_src_configure
	fi
}

multilib_src_compile() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl autotools-utils_src_compile -C xcbgen \
			top_builddir="${BUILD_DIR}"
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl autotools-utils_src_install -C xcbgen \
			top_builddir="${BUILD_DIR}"
	fi
}

pkg_postinst() {
	ewarn "Please rebuild both libxcb and xcb-util if you are upgrading from version 1.6"
}
