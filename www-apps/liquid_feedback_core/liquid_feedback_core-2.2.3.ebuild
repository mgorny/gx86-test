# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit eutils toolchain-funcs

MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="http://www.public-software-group.org/liquid_feedback"
SRC_URI="http://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-db/postgresql-base"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="-I $(pg_config --includedir)" \
		LDFLAGS="${LDFLAGS} -L $(pg_config --libdir)" \
		LDLIBS="-lpq $(pg_config --libs)"
}

src_install() {
	dobin lf_update lf_update_suggestion_order lf_export
	insinto /usr/share/${PN}
	doins -r {core,init,demo,test}.sql update
	dodoc README "${FILESDIR}"/postinstall-en.txt
}
