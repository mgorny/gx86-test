# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=(python2_7)
inherit eutils distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/kevinmehall/pithos.git
					https://github.com/kevinmehall/pithos.git"
else
	MY_PV="759fd22b993b063527866dedfb335a88d0c71766"
	SRC_URI="https://github.com/kevinmehall/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A Pandora Radio (pandora.com) player for the GNOME Desktop"
HOMEPAGE="http://kevinmehall.net/p/pithos/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:0.10[aac,http,mp3]
	gnome? ( gnome-base/gnome-settings-daemon )
	!gnome? ( dev-libs/keybinder[python] )"

src_prepare() {
	# replace the build system with something more sane
	epatch "${FILESDIR}"/${PN}-detect-datadir.patch
	cp "${FILESDIR}"/setup.py "${S}"

	distutils-r1_src_prepare
}
