# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

DESCRIPTION="Shows legacy tray icons on top"
HOMEPAGE="https://extensions.gnome.org/extension/495/topicons/"
SRC_URI="http://94.247.144.115/repo/topicons/snapshot/topicons-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-admin/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.10
"
DEPEND="app-arch/xz-utils"

S="${WORKDIR}/topicons-${PV}"

src_install() {
	local uuid='topIcons@adel.gadllah@gmail.com'
	insinto "/usr/share/gnome-shell/extensions/${uuid}"
	doins *
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
