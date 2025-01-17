# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 virtualx

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="2.0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="glade"

# FIXME: We could avoid the glade conditional and dep completely if upstream
# would have a --with-glade-catalogdir that would allow to pass the system
# glade catalog dir, instead of needing gladeui-1.0.pc installed from dev-util/glade
RDEPEND=">=x11-libs/gtk+-2.12:2
	>=dev-libs/libxml2-2.5:2
	>=dev-libs/glib-2.14:2
	glade? ( >=dev-util/glade-3.2:3 )
	kernel_Darwin? ( x11-libs/ige-mac-integration )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README"
	G2CONF="${G2CONF}
		$(use_enable glade glade-catalog)"
}

src_prepare() {
	gnome2_src_prepare

	# Skip broken test until upstream bug #621383 is solved
	sed -i -e "/guess-language/d" tests/test-languagemanager.c || die

	# The same for another broken test, upstream bug #631214
	sed -i -e "/get-language/d" tests/test-languagemanager.c || die

	# Patch from 3.x for bug #394925
	epatch "${FILESDIR}/${P}-G_CONST_RETURN.patch"
}

src_test() {
	Xemake check || die "Test phase failed"
}

src_install() {
	gnome2_src_install

	insinto /usr/share/${PN}-2.0/language-specs
	doins "${FILESDIR}"/2.0/gentoo.lang
}
