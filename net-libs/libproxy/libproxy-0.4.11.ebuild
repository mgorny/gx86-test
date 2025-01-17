# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
PYTHON_DEPEND="python? 2:2.6"

inherit cmake-utils eutils flag-o-matic mono python

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="gnome kde mono networkmanager perl python spidermonkey test webkit"

# NOTE: mozjs/spidermonkey might still cause problems like #373397 ?
# NOTE: webkit-gtk:3, not :2, needed for libjavascriptcoregtk support
RDEPEND="gnome? ( >=dev-libs/glib-2.26:2 )
	kde? ( >=kde-base/kdelibs-4.4.5 )
	mono? ( dev-lang/mono )
	networkmanager? ( sys-apps/dbus )
	perl? (	dev-lang/perl )
	spidermonkey? ( >=dev-lang/spidermonkey-1.8.5:0 )
	webkit? ( >=net-libs/webkit-gtk-1.6:3 )"
DEPEND="${RDEPEND}
	kde? ( dev-util/automoc )
	virtual/pkgconfig"
# avoid dependency loop, bug #467696
PDEPEND="networkmanager? ( net-misc/networkmanager )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"

	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# Gentoo's spidermonkey doesn't set Version: in mozjs18[57].pc
	epatch "${FILESDIR}/${P}-mozjs.pc.patch"

	# get-pac-test freezes when run by the ebuild, succeeds when building
	# manually; virtualx.eclass doesn't help :(
	epatch "${FILESDIR}/${PN}-0.4.10-disable-pac-test.patch"

	epatch "${FILESDIR}"/${P}-macosx.patch

	# prevent dependency loop with networkmanager, libsoup, glib-networking; bug #467696
	epatch "${FILESDIR}/${PN}-0.4.11-avoid-nm-build-dep.patch"
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lsocket -lnsl

	# WITH_VALA just copies the .vapi file over and needs no deps,
	# hence always enable it unconditionally
	local mycmakeargs=(
			-DPERL_VENDORINSTALL=ON
			-DCMAKE_C_FLAGS="${CFLAGS}"
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
			$(cmake-utils_use_with gnome GNOME3)
			$(cmake-utils_use_with kde KDE4)
			$(cmake-utils_use_with mono DOTNET)
			$(cmake-utils_use_with networkmanager NM)
			$(cmake-utils_use_with perl PERL)
			$(cmake-utils_use_with python PYTHON)
			$(cmake-utils_use_with spidermonkey MOZJS)
			$(cmake-utils_use_with webkit WEBKIT)
			$(cmake-utils_use_with webkit WEBKIT3)
			-DWITH_VALA=ON
			$(cmake-utils_use test BUILD_TESTING)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	use python && python_mod_optimize ${PN}.py
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}.py
}
