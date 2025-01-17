# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit cmake-utils

MY_P="mirall-${PV/_/}"

DESCRIPTION="Synchronize files from ownCloud Server with your computer"
HOMEPAGE="http://owncloud.org/"
SRC_URI="http://download.owncloud.com/desktop/stable/${MY_P}.tar.bz2"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc samba +sftp test +qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND=">=dev-db/sqlite-3.4:3
	qt4? (
		dev-libs/qtkeychain[qt4]
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qttest:4
		dev-qt/qtwebkit:4
	)
	qt5? (
		dev-libs/qtkeychain[qt5]
		dev-qt/linguist-tools:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsql:5
		dev-qt/qttest:5
		dev-qt/qtwebkit:5[printsupport,widgets]
	)
	net-libs/neon[ssl]
	sys-fs/inotify-tools
	virtual/libiconv
	samba? ( >=net-fs/samba-3.5 )
	sftp? ( >=net-libs/libssh-0.5 )
	!net-misc/ocsync"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	test? ( dev-util/cmocka )"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-1.5.3-man-page-location-fix.patch )

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DWITH_ICONV=ON
		$(cmake-utils_use_with doc DOC)
		$(cmake-utils_use test UNIT_TESTING)
		$(cmake-utils_use_find_package samba Libsmbclient)
		$(cmake-utils_use_find_package sftp LibSSH)
		$(cmake-utils_use_build qt4 WITH_QT4)
	)

	cmake-utils_src_configure
}

src_test() {
	# 1 test needs an existing ${HOME}/.config directory
	mkdir "${T}"/.config
	export HOME="${T}"
	cmake-utils_src_test
}

pkg_postinst() {
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}
