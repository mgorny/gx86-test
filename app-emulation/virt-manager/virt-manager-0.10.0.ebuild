# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

#BACKPORTS=

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit eutils gnome2 distutils-r1

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="http://virt-manager.org"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://virt-manager.org/download/sources/${PN}/${P}.tar.gz
	${BACKPORTS+http://dev.gentoo.org/~cardoe/distfiles/${P}-${BACKPORTS}.tar.xz}"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gnome-keyring policykit sasl"

RDEPEND="!app-emulation/virtinst
	x11-libs/gtk+:3[introspection]
	|| (
		dev-python/libvirt-python[${PYTHON_USEDEP}]
		>=app-emulation/libvirt-0.7.0[python,${PYTHON_USEDEP}]
	)
	>=app-emulation/libvirt-glib-0.0.9[introspection,python,${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/urlgrabber[${PYTHON_USEDEP}]
	gnome-base/dconf
	>=net-libs/gtk-vnc-0.3.8[gtk3,introspection,python,${PYTHON_USEDEP}]
	net-misc/spice-gtk[gtk3,introspection,python,sasl?,${PYTHON_USEDEP}]
	x11-libs/vte:2.90[introspection]
	gnome-keyring? ( dev-python/gnome-keyring-python )
	policykit? ( sys-auth/polkit[introspection] )"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool"

DOCS=( README NEWS )

python_prepare_all() {
	epatch_user
	distutils-r1_python_prepare_all
}

distutils-r1_python_compile() {
	local defgraphics=

	esetup.py configure \
		--qemu-user=qemu \
		--default-graphics=spice
}

python_install_all() {
	python_fix_shebang "${ED}/usr/share/virt-manager/virt-clone"
	python_fix_shebang "${ED}/usr/share/virt-manager/virt-convert"
	python_fix_shebang "${ED}/usr/share/virt-manager/virt-image"
	python_fix_shebang "${ED}/usr/share/virt-manager/virt-install"
	python_fix_shebang "${ED}/usr/share/virt-manager/virt-manager"

	distutils-r1_python_install_all
}

pkg_preinst() {
	gnome2_pkg_preinst

	cd "${ED}"
	export GNOME2_ECLASS_ICONS=$(find 'usr/share/virt-manager/icons' -maxdepth 1 -mindepth 1 -type d 2> /dev/null)
}
