# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit cmake-utils

DESCRIPTION="Razor-qt module for power management (logout/shutdown/reboot/suspend/hibernate)"
HOMEPAGE="http://razor-qt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="http://www.razor-qt.org/downloads/files/razorqt-${PV}.tar.bz2"
	KEYWORDS="amd64 ~ppc x86"
	S="${WORKDIR}/razorqt-${PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="razorqt-base/razorqt-libs"
RDEPEND="${DEPEND}
	razorqt-base/razorqt-data
	|| ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils )"

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_POWER=On
	)
	cmake-utils_src_configure
}
