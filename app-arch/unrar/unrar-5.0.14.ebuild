# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

MY_PN=${PN}src

DESCRIPTION="Uncompress rar files"
HOMEPAGE="http://www.rarlab.com/rar_add.htm"
SRC_URI="http://www.rarlab.com/rar/${MY_PN}-${PV}.tar.gz"

LICENSE="unRAR"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="!<=app-arch/unrar-gpl-0.0.1_p20080417"

S=${WORKDIR}/unrar

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.0.2-build.patch
	sed -i \
		-e "/libunrar/s:.so:$(get_libname ${PV%.*.*}):" \
		-e "s:-shared:& -Wl,-soname -Wl,libunrar$(get_libname ${PV%.*.*}):" \
		makefile || die
}

src_compile() {
	unrar_make() {
		emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" STRIP=true "$@"
	}

	unrar_make CXXFLAGS+=" -fPIC" lib
	ln -s libunrar$(get_libname ${PV%.*.*}) libunrar$(get_libname)
	ln -s libunrar$(get_libname ${PV%.*.*}) libunrar$(get_libname ${PV})

	# The stupid code compiles a lot of objects differently if
	# they're going into a lib (-DRARDLL) or into the main app.
	# So for now, we can't link the main app against the lib.
	unrar_make clean
	unrar_make
}

src_install() {
	dobin unrar
	dodoc readme.txt

	dolib.so libunrar*

	insinto /usr/include/libunrar${PV%.*.*}
	doins *.hpp
	dosym libunrar${PV%.*.*} /usr/include/libunrar
}
