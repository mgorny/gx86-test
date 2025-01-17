# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils toolchain-funcs versionator

DESCRIPTION="Userspace utils and init scripts for the AppArmor application security system"
HOMEPAGE="http://apparmor.net/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-tex/latex2html )"

S=${WORKDIR}/apparmor-${PV}/parser

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	# remove warning about missing file that controls features
	# we don't currently support
	sed -e "/installation problem/ctrue" -i rc.apparmor.functions || die
}

src_compile()  {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" arch manpages
	use doc && emake pdf
}

src_install() {
	default

	dodir /etc/apparmor.d

	newinitd "${FILESDIR}"/${PN}-init ${PN}

	use doc && dodoc techdoc.pdf
}
