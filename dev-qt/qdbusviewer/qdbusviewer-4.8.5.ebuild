# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils qt4-build

DESCRIPTION="Graphical tool that lets you introspect D-Bus objects and messages"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtdbus-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="tools/qdbus/qdbusviewer"
	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools/qdbus"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl"

	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install

	newicon tools/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer.png
	make_desktop_entry qdbusviewer QDBusViewer qdbusviewer 'Qt;Development'
}
