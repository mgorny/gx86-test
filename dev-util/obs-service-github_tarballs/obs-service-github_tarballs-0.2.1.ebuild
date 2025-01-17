# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

[[ -n ${OBS_SERVICE_NAME} ]] || OBS_SERVICE_NAME=${PN/obs-service-/}
OBS_PROJECT="openSUSE:Tools"

inherit obs-download

DESCRIPTION="Open Build Service client module - ${OBS_SERVICE_NAME} service"
HOMEPAGE="http://en.opensuse.org/openSUSE:OSC"
LICENSE="GPL-2"
SLOT="0"

SRC_URI="${OBS_URI}/${P}.tar.gz"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/osc
	dev-util/suse-build
	dev-vcs/git
"

src_install() {
	exeinto /usr/libexec/obs/service
	doexe ${OBS_SERVICE_NAME}
	insinto /usr/libexec/obs/service
	doins *.service
}
