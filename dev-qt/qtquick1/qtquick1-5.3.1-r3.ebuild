# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit qt5-build

DESCRIPTION="Legacy declarative framework for Qt4 compatibility for building dynamic user interfaces"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

IUSE="designer +opengl webkit xml"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtscript-${PV}:5[debug=]
	>=dev-qt/qtsql-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	designer? (
		>=dev-qt/designer-${PV}:5[debug=]
		>=dev-qt/qtdeclarative-${PV}:5[debug=]
	)
	opengl? ( >=dev-qt/qtopengl-${PV}:5[debug=] )
	webkit? ( >=dev-qt/qtwebkit-${PV}:5[debug=,widgets] )
	xml? ( >=dev-qt/qtxmlpatterns-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod designer designer \
		src/plugins/plugins.pro

	qt_use_disable_mod opengl opengl \
		src/imports/imports.pro \
		tools/qml/qml.pri

	qt_use_disable_mod webkit webkitwidgets \
		src/imports/imports.pro

	qt_use_disable_mod xml xmlpatterns \
		src/declarative/declarative.pro \
		src/declarative/util/util.pri

	qt5-build_src_prepare
}
