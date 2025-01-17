# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils toolchain-funcs versionator

MY_P="${PN}-$(get_version_component_range 3)"

DESCRIPTION="Tools for working with the ipkg binary package format"
HOMEPAGE="http://www.openembedded.org/"
SRC_URI="http://handhelds.org/download/packages/ipkg-utils/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~x86"
IUSE="minimal"

DEPEND="!minimal? (
		app-crypt/gnupg
		net-misc/curl
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="ipkg.py"

src_prepare() {
	epatch "${FILESDIR}/${PN}-tar_call_fixes.patch"
	epatch "${FILESDIR}/${P}-hashlib.patch"

	sed '/python setup.py build/d' -i Makefile

	if use minimal; then
		elog "ipkg-upload is not installed when the \`minimal' USE flag is set.  If you"
		elog "need ipkg-upload then rebuild this package without the \`minimal' USE flag."
	fi
}

src_compile() {
	distutils_src_compile
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	distutils_src_install
	use minimal && rm "${ED}usr/bin/ipkg-upload"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "Consider installing sys-apps/fakeroot for use with the ipkg-build command,"
	elog "that makes it possible to build packages as a normal user."
}
