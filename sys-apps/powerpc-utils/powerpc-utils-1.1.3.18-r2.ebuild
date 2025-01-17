# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils versionator toolchain-funcs

BASEVER=$(get_version_component_range 1-3)
DEBREV=$(get_version_component_range 4)

DESCRIPTION="PowerPC utilities including nvsetenv, and additional OldWorld apps"
SRC_URI="http://http.us.debian.org/debian/pool/main/p/powerpc-utils/${PN}_${BASEVER}.orig.tar.gz
	http://http.us.debian.org/debian/pool/main/p/powerpc-utils/${PN}_${BASEVER}-${DEBREV}.diff.gz
	mirror://gentoo/${PN}-cleanup.patch.bz2"

HOMEPAGE="http://http.us.debian.org/debian/pool/main/p/powerpc-utils/"
KEYWORDS="-* ppc ppc64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="GPL-2"

S="${WORKDIR}/pmac-utils"

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${BASEVER}-${DEBREV}.diff
	epatch "${WORKDIR}"/${PN}-cleanup.patch

	# use users CFLAGS, LDFLAGS and CC, bug 280400
	sed -i -e "/LDFLAGS =/d" -e "/CC\t=/d" -e "s/CFLAGS\t=/CFLAGS +=/" \
		-e "s/-g -O2/-Wstrict-prototypes/" Makefile || die "sed failed"
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	into /usr
	dosbin autoboot backlight bootsched clock fblevel fdeject fnset \
		|| die "dosbin failed"
	dosbin macos mousemode nvsetenv nvsetvol nvvideo sndvolmix trackpad \
		|| die "dosbin failed"
	doman autoboot.8 bootsched.8 clock.8 fblevel.8 fdeject.8 macos.8 \
		|| die "doman failed"
	doman mousemode.8 nvsetenv.8 nvsetvol.8 nvvideo.8 sndvolmix.8 trackpad.8 \
		|| die "doman failed"

	ewarn "The lsprop utility has been moved into the ibm-powerpc-utils package."
}
