# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit eutils

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="http://www.aquamaniac.de/aqbanking/"
SRC_URI="http://www.aquamaniac.de/sites/download/download.php?package=03&release=95&file=01&dummy=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="chipcard debug doc examples gtk ofx"

RDEPEND=">=app-misc/ktoblzcheck-1.39
	>=dev-libs/gmp-5
	>=sys-libs/gwenhywfar-4.3.3[gtk?]
	virtual/libintl
	ofx? ( >=dev-libs/libofx-0.9.5 )
	chipcard? ( >=sys-libs/libchipcard-5.0.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

MAKEOPTS="${MAKEOPTS} -j1" # 5.0.x fails with -j9 on quadcore

src_configure() {
	local backends="aqhbci aqnone aqpaypal"
	use ofx && backends="${backends} aqofxconnect"

	local mytest
	use gtk && mytest="--enable-gui-tests"

	econf \
		$(use_enable debug) \
		$(use_enable doc full-doc) \
		--with-backends="${backends}" \
		--with-docpath=/usr/share/doc/${PF}/apidoc \
		${mytest}
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${ED}"/usr/share/doc/aq{banking,hbci,paypal}

	dodoc AUTHORS ChangeLog NEWS README TODO

	newdoc src/plugins/backends/aqhbci/tools/aqhbci-tool/README \
		README.aqhbci-tool
	newdoc src/plugins/backends/aqpaypal/tools/aqpaypal-tool/README \
		README.aqpaypal-tool

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h} tutorials/README
	fi

	prune_libtool_files --all
}
