# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit autotools eutils

DESCRIPTION="A portable, efficient middleware for different kinds of mail access"
HOMEPAGE="http://libetpan.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="berkdb debug gnutls ipv6 liblockfile sasl ssl"

DEPEND="berkdb? ( sys-libs/db )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( ssl? ( dev-libs/openssl ) )
	sasl? ( dev-libs/cyrus-sasl )
	liblockfile? ( net-libs/liblockfile )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-nonnull.patch
	# respect CFLAGS - bug #373723
	sed -i -e "s/-O2 -g//" configure.ac
	eautoreconf
}

src_configure() {
	local sslconf

	if use ssl; then
		if use gnutls; then
			sslconf="--with-gnutls --without-openssl"
		else
			sslconf="--without-gnutls --with-openssl"
		fi
	else
		if use gnutls; then
			sslconf="--with-gnutls --without-openssl"
		else
			sslconf="--without-gnutls --without-openssl"
		fi
	fi

	# in Prefix emake uses SHELL=${BASH}, export CONFIG_SHELL to the same so
	# libtool recognises it as valid shell (bug #300211)
	use prefix && export CONFIG_SHELL=${BASH}
	# The configure script contains an error, in that it doesn't check the
	# argument of --enable-{debug,optim}, hence --disable-debug results in
	# --enable-debug=no, which isn't checked and debugging flags are blindly
	# injected.  So, avoid passing --disable-debug when we don't need it.
	econf \
		$(use debug && echo --enable-debug) \
		$(use_enable berkdb db) \
		$(use_with sasl) \
		$(use_enable ipv6) \
		$(use_enable liblockfile lockfile) \
		${sslconf} \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS ChangeLog || die
}

pkg_postinst() {
	echo
	ewarn "The soname for libetpan has changed after libetpan-1.0."
	ewarn "If you have upgraded from that or earlier version, it is recommended to run"
	ewarn "revdep-rebuild to fix any linking errors caused by this change."
	echo
}
