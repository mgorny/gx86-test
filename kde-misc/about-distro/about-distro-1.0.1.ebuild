# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KDE_LINGUAS="bs cs da de el es fi fr gl hu lt nl pl pt pt_BR ro ru sk sl sv tr
ug uk"
inherit kde4-base

DESCRIPTION="KCM displaying distribution and system information"
HOMEPAGE="https://projects.kde.org/projects/playground/base/about-distro"
SRC_URI="http://www.gentoo.org/images/glogo-small.png"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI+=" mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="git://anongit.kde.org/${PN}"
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="4"
IUSE="debug"

RDEPEND="${DEPEND}
	sys-apps/lsb-release
"

src_install() {
	kde4-base_src_install

	insinto /usr/share/config
	doins "${FILESDIR}"/kcm-about-distrorc

	insinto /usr/share/${PN}
	doins "${DISTDIR}"/glogo-small.png
}
