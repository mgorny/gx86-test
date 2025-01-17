# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
inherit gkrellm-plugin

IUSE=""
DESCRIPTION="GKrellM2 Plugin that monitors a METAR station and displays weather
info"
SRC_URI="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/${P}.tgz"
HOMEPAGE="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/index.html"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=dev-lang/perl-5.6.1
	>=net-misc/wget-1.5.3
	!x11-misc/bbweather"
DEPEND=">=sys-apps/sed-4.0.5"

src_prepare() {
	epatch "${FILESDIR}/${P}-Respect-LDFLAGS.patch"
	sed -i \
		-e "s:/usr/share/gkrellm:/usr/bin:g" \
		gkrellweather.c || die
}

src_compile() {
	emake PREFIX=/usr || die
}

src_install () {
	gkrellm-plugin_src_install

	exeinto /usr/bin
	doexe GrabWeather
}
