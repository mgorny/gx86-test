# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Educational: vocabulary trainer"
HOMEPAGE="http://www.kde.org/applications/education/parley
http://edu.kde.org/applications/school/parley"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma"

DEPEND="
	$(add_kdebase_dep libkdeedu)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkdeedu/keduvocdocument
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with plasma)
	)

	kde4-base_src_configure
}
