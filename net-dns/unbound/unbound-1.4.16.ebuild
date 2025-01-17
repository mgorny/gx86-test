# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit eutils flag-o-matic python user

DESCRIPTION="A validating, recursive and caching DNS resolver"
HOMEPAGE="http://unbound.net/"
SRC_URI="http://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="debug gost python selinux static-libs test threads"

RDEPEND="dev-libs/expat
	dev-libs/libevent
	>=dev-libs/openssl-0.9.8
	>=net-libs/ldns-1.6.5[ssl,gost?]
	selinux? ( sec-policy/selinux-bind )"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	test? (
		net-dns/ldns-utils[examples]
		dev-util/splint
		app-text/wdiff
	)"

# bug #347415
RDEPEND="${RDEPEND}
	net-dns/dnssec-root"

pkg_setup() {
	enewgroup unbound
	enewuser unbound -1 -1 /etc/unbound unbound

	use python && python_pkg_setup
}

src_prepare() {
	# To avoid below error messages, set 'trust-anchor-file' to same value in
	# 'auto-trust-anchor-file'.
	# [23109:0] error: Could not open autotrust file for writing,
	# /etc/dnssec/root-anchors.txt: Permission denied
	epatch "${FILESDIR}/${PN}-1.4.12-gentoo.patch"
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack || die
	econf \
		--with-pidfile="${EPREFIX}"/var/run/unbound.pid \
		--with-ldns="${EPREFIX}"/usr \
		--with-libevent="${EPREFIX}"/usr \
		--with-rootkey-file="${EPREFIX}"/etc/dnssec/root-anchors.txt \
		$(use_enable debug) \
		$(use_enable gost) \
		$(use_enable static-libs static) \
		$(use_with threads pthreads) \
		$(use_with python pyunbound) \
		$(use_with python pythonmodule) \
		--disable-rpath || die

		# http://unbound.nlnetlabs.nl/pipermail/unbound-users/2011-April/001801.html
		# $(use_enable debug lock-checks) \
		# $(use_enable debug alloc-checks) \
		# $(use_enable debug alloc-lite) \
		# $(use_enable debug alloc-nonregional) \
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# bug #299016
	if use python ; then
		find "${ED}" -name '_unbound.{la,a}' -delete || die
	fi
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -type f -delete || die
	fi

	newinitd "${FILESDIR}/unbound.initd" unbound || die "newinitd failed"
	newconfd "${FILESDIR}/unbound.confd" unbound || die "newconfd failed"

	dodoc doc/{README,CREDITS,TODO,Changelog,FEATURES} || die "dodoc failed"

	# bug #315519
	#exeinto /usr/libexec/munin/plugins
	#doexe contrib/unbound_munin_ || die "doexe failed"
	dodoc contrib/unbound_munin_ || die "dodoc failed"

	docinto selinux
	dodoc contrib/selinux/* || die "dodoc failed"

	exeinto /usr/share/${PN}
	doexe contrib/update-anchor.sh || die "doexe failed"
}

pkg_postinst() {
	use python && python_mod_optimize unbound.py unboundmodule.py
}

pkg_postrm() {
	use python && python_mod_cleanup unbound.py unboundmodule.py
}
