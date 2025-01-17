# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit eutils versionator

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"

SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-fbsd"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	epatch "${FILESDIR}/${P}-check-builtin.patch"
}

src_compile() {
	# not parallel-safe yet
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
