# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit toolchain-funcs eutils multilib

DESCRIPTION="High Security, Zero-Knowledge Online Backup"
HOMEPAGE="https://www.cyphertite.com/"
SRC_URI="https://www.cyphertite.com/snapshots/source/${PV}/${PN}-full-${PV}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/xz-utils:0=
	dev-db/sqlite:3=
	>=dev-libs/openssl-1.0.1g:0=
	dev-libs/expat:0=
	dev-libs/libbsd:0=
	dev-libs/libedit:0=
	dev-libs/libevent:0=
	>=dev-libs/lzo-2.0:2=
	>=net-misc/curl-7.15.1:0=
	sys-libs/zlib:0=
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix build system that assumes that modules are installed to the live system
	epatch "${FILESDIR}/${P}-fix-build.patch" "${FILESDIR}/${P}-cflags.patch"
}

src_compile() {
	# Package has a home grown Makefile system. Make it work for Gentoo
	emake INCDIR="${S}" WARNFLAGS="-Wall" OPTLEVEL="" DEBUG="" CC="$(tc-getCC)" \
		AR="$(tc-getAR)" LOCALBASE="/usr" LIB.LINKSTATIC="" LIB.LINKDYNAMIC=""
}

src_install() {
	# Only the main executable needs to be installed
	emake -C cyphertite/cyphertite DESTDIR="${D}" LOCALBASE="usr" LIBDIR="usr/$(get_libdir)" LNFORCE="-s" install

	# Fix up broken man symlinks
	rm "${D}"usr/share/man/man1/ct*.1 || die
	dosym /usr/share/man/man1/cyphertite.1.bz2 /usr/share/man/man1/ct.1.bz2
	dosym /usr/share/man/man1/cyphertitectl.1.bz2 /usr/share/man/man1/ctctl.1.bz2
	dosym /usr/share/man/man1/cyphertitefb.1.bz2 /usr/share/man/man1/ctfb.1.bz2
}
