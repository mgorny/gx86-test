# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

PATCH_VER="1.1"
UCLIBC_VER="1.0"

# Hardened gcc 4 stuff
PIE_VER="10.1.5"
SPECS_VER="0.9.4"

# arch/libc configurations known to be stable or untested with {PIE,SSP,FORTIFY}-by-default
PIE_GLIBC_STABLE="x86 amd64 ppc ppc64 arm sparc"
PIE_UCLIBC_STABLE="x86 arm"
#SSP_STABLE="amd64 x86 ppc ppc64 ~arm ~sparc"
#SSP_UCLIBC_STABLE=""

inherit eutils toolchain

DESCRIPTION="The GNU Compiler Collection"

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ ) FDL-1.2+"
KEYWORDS="alpha amd64 arm -hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.3.2/gcc-4.3.2-softfloat.patch
}
