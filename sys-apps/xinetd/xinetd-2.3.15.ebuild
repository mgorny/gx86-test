# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="powerful replacement for inetd"
HOMEPAGE="http://www.xinetd.org/"
SRC_URI="http://www.xinetd.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="perl rpc tcpd"

DEPEND="tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )
	rpc? ( net-libs/libtirpc )"
RDEPEND="${DEPEND}
	perl? ( dev-lang/perl )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.3.14-DESTDIR.patch
	epatch "${FILESDIR}"/${PN}-2.3.14-install-contrib.patch
	epatch "${FILESDIR}"/${PN}-2.3.14-config.patch
	find -name Makefile.in -exec sed -i 's:\<ar\>:$(AR):' {} +
}

src_configure() {
	if ! use rpc ; then
		append-cppflags -DNO_RPC
		export ac_cv_header_{rpc_{rpc,rpcent,pmap_clnt},netdb}_h=no
	fi
	tc-export AR PKG_CONFIG
	LIBS=$(${PKG_CONFIG} --libs libtirpc) \
	econf \
		$(use_with tcpd libwrap) \
		--with-loadavg
}

src_install() {
	emake DESTDIR="${ED}" install install-contrib
	use perl || rm -f "${ED}"/usr/sbin/xconv.pl

	newinitd "${FILESDIR}"/xinetd.rc6 xinetd
	newconfd "${FILESDIR}"/xinetd.confd xinetd

	newdoc contrib/xinetd.conf xinetd.conf.dist.sample
	dodoc AUDIT INSTALL README TODO CHANGELOG
}
