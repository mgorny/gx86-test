# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

inherit eutils autotools

DESCRIPTION="Adaptive readahead daemon"
HOMEPAGE="http://sourceforge.net/projects/preload/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="vanilla"

WANT_AUTOCONF="2.56"

RDEPEND=">=dev-libs/glib-2.6:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/help2man"

src_prepare() {
	epatch "${FILESDIR}"/00-patch-configure.diff
	epatch "${FILESDIR}"/02-patch-preload_conf.diff
	epatch "${FILESDIR}"/02-patch-preload_sysconfig.diff
	epatch "${FILESDIR}"/${PN}-0.6.4-use-help2man-as-usual.patch
	epatch "${FILESDIR}"/${PN}-0.6.4-use-make-dependencies.patch
	use vanilla || epatch "${FILESDIR}"/000{1,2,3}-*.patch
	cat "${FILESDIR}"/preload-0.6.4.init.in-r1 > preload.init.in || die

	eautoreconf
}

src_configure() {
	econf --localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	# Remove log and state file from image or they will be
	# truncated during merge
	rm "${ED}"/var/lib/preload/preload.state || die "cleanup failed"
	rm "${ED}"/var/log/preload.log || die "cleanup failed"
	keepdir /var/lib/preload
	keepdir /var/log
}

pkg_postinst() {
	elog "You probably want to add preload to the default runlevel like so:"
	elog "# rc-update add preload default"
}
