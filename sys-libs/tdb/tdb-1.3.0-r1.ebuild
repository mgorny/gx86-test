# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit waf-utils multilib-minimal python-single-r1 eutils

DESCRIPTION="A simple database API"
HOMEPAGE="http://tdb.samba.org/"
SRC_URI="http://samba.org/ftp/tdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="
	${RDEPEND}
	app-text/docbook-xml-dtd:4.2"

WAF_BINARY="${S}/buildtools/bin/waf"

src_prepare() {
	epatch "${FILESDIR}/add_missing_stdbool_h_include.patch"
	multilib_copy_sources
}

multilib_src_configure() {
	local extra_opts=()
	if ! multilib_is_native_abi || ! use python; then
		extra_opts+=( --disable-python )
	fi

	waf-utils_src_configure \
		"${extra_opts[@]}"
}

multilib_src_compile() {
	# need to avoid parallel building, this looks like the sanest way with waf-utils/multiprocessing eclasses
	unset MAKEOPTS
	waf-utils_src_compile
}

multilib_src_test() {
	# the default src_test runs 'make test' and 'make check', letting
	# the tests fail occasionally (reason: unknown)
	emake check
}

multilib_src_install() {
	waf-utils_src_install
}
