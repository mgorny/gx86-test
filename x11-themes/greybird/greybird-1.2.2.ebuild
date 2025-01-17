# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MY_PN=${PN/g/G}

DESCRIPTION="The default theme from Xubuntu"
HOMEPAGE="http://shimmerproject.org/project/greybird/ http://github.com/shimmerproject/Greybird"
SRC_URI="https://github.com/shimmerproject/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-NC-SA-3.0 || ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="ayatana gnome"

RDEPEND=">=x11-themes/gtk-engines-murrine-0.90"
DEPEND=""

RESTRICT="binchecks strip"

src_unpack() {
	unpack ${A}
	mv ${MY_PN}-* "${S}" || die
}

src_install() {
	dodoc README
	rm -f README LICENSE*

	insinto /usr/share/themes/${MY_PN}_compact/xfwm4
	doins xfwm4_compact/*
	rm -rf xfwm4_compact

	use ayatana || rm -rf unity
	use gnome || rm -rf metacity-1

	insinto /usr/share/themes/${MY_PN}
	doins -r *
}
