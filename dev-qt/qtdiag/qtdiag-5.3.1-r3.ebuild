# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="Tool for reporting diagnostic information about Qt and its environment"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

IUSE="+opengl +ssl"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,opengl=]
	>=dev-qt/qtnetwork-${PV}:5[debug=,ssl=]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qtdiag
)
