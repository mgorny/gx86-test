# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
DISTUTILS_NO_PARALLEL_BUILD=1

inherit distutils-r1 gnome2-utils vcs-snapshot

DESCRIPTION="twitter client designed for multiple columns of multiple accounts"
HOMEPAGE="https://launchpad.net/polly"
SRC_URI="https://launchpad.net/${PN}/1.0/pre-alpha-2/+download/Polly-${PV}%20%28pre-alpha%203.10%29.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-NC-SA-3.0 GPL-2 GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python
	dev-python/gtkspell-python
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/socksipy[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-0.93.10-desktop.patch )

python_install_all() {
	insinto /etc/gconf/schemas
	doins share/gconf/schemas/${PN}.schemas
	rm -rf share/gconf || die

	distutils-r1_python_install_all
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}

pkg_postrm() {
	gnome2_gconf_uninstall
}
