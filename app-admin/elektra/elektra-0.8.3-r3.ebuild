# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-multilib eutils

DESCRIPTION="universal and secure framework to store config parameters in a hierarchical key-value pair mechanism"
HOMEPAGE="http://freedesktop.org/wiki/Software/Elektra"
SRC_URI="ftp://ftp.markus-raab.org/${PN}/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc examples iconv inifile simpleini static-libs syslog tcl test xml yajl"

RDEPEND=">=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	yajl? (
		<dev-libs/yajl-2[${MULTILIB_USEDEP}]
		>=dev-libs/yajl-1.0.11-r1[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	sys-devel/libtool
	doc? ( app-doc/doxygen )"

# tries to write to user's home directory (and doesn't respect HOME)
RESTRICT="test"

src_prepare() {
	#fix QA issues with upstream patches
	epatch "${FILESDIR}/${P}-introduce-attributes.patch"
	epatch "${FILESDIR}/${P}-fix-yajl-if-user-config.patch"

	#move doc files to correct location
	sed -e "s/elektra-api/${PF}/" \
		-i cmake/ElektraCache.cmake || die

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local my_plugins="ccode;dump;error;fstab;glob;hexcode;hidden;hosts;network;ni;null;path;resolver;struct;success;template;timeofday;tracer;type;validation"

	use dbus    && my_plugins+=";dbus"
	use doc     && my_plugins+=";doc"
	use iconv   && my_plugins+=";iconv"
	use inifile && my_plugins+=";simpleini"
	use syslog  && my_plugins+=";syslog"
	use tcl     && my_plugins+=";tcl"
	use xml     && my_plugins+=";xmltool"
	use yajl    && my_plugins+=";yajl"

	mycmakeargs=(
		"-DPLUGINS=${my_plugins}"
		"-DLATEX_COMPILER=OFF"
		"-DTARGET_CMAKE_FOLDER=share/cmake/Modules"
		$(multilib_is_native_abi && cmake-utils_use doc BUILD_DOCUMENTATION \
			|| echo -DBUILD_DOCUMENTATION=OFF)
		$(multilib_is_native_abi && cmake-utils_use examples BUILD_EXAMPLES \
			|| echo -DBUILD_EXAMPLES=OFF)
		$(cmake-utils_use static-libs BUILD_STATIC)
		$(cmake-utils_use test BUILD_TESTING)
	)

	cmake-utils_src_configure
}

src_compile() {
	dodir /usr/share/man/man3
	cmake-multilib_src_compile
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi && use doc; then
		rm -rf "${D}/usr/share/doc/${PF}/man" || die
		cd doc/man/man3 || die
		local my_f
		for my_f in *.3 ; do
			newman ${my_f} ${PN}-${my_f}
			elog "installed /usr/share/man/man3/${my_f} as ${PN}-${my_f}"
		done
	fi
}

multilib_src_install_all() {
	dodoc doc/{AUTHORS,CHANGES,NEWS,README,todo/TODO}
}
