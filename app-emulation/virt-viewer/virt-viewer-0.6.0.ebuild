# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils gnome2

DESCRIPTION="Graphical console client for connecting to virtual machines"
HOMEPAGE="http://virt-manager.org/"
SRC_URI="http://virt-manager.org/download/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sasl +spice +vnc"

RDEPEND=">=app-emulation/libvirt-0.10.0[sasl?]
	>=dev-libs/libxml2-2.6
	x11-libs/gtk+:3
	spice? ( >=net-misc/spice-gtk-0.22[sasl?,gtk3] )
	vnc? ( >=net-libs/gtk-vnc-0.5.0[sasl?,gtk3] )"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	spice? ( >=app-emulation/spice-protocol-0.10.1 )"

REQUIRED_USE="|| ( spice vnc )"

pkg_setup() {
	G2CONF="$(use_with vnc gtk-vnc) $(use_with spice spice-gtk)"
	G2CONF="${G2CONF} --with-gtk=3.0 --without-ovirt"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-c99-compat.patch"
	epatch_user
}

src_test() {
	default
}

src_install() {
	default
}
