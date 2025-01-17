# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit versionator flag-o-matic

DESCRIPTION="a relational database in shared library form"
HOMEPAGE="http://www.haildb.com/"
SRC_URI="http://launchpad.net/haildb/$(get_major_version).x/$(get_version_component_range 1-2)/+download/${P}.tar.gz"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug tcmalloc zlib"

RDEPEND="tcmalloc? ( dev-util/google-perftools )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	sys-devel/bison"

src_configure() {
	local myconf

	if use debug; then
		# Since --with-debug would turn off optimisations as well as
		# enabling debug, we just enable debug through the
		# preprocessor then.
		append-flags -DDEBUG
	else
		myconf="${myconf} --disable-assert"
	fi

	# never allow it to find valgrind, easier this way
	export ac_cv_header_valgrind_memcheck_h=no

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--enable-fast-install \
		--disable-silent-rules \
		--disable-mtmalloc \
		$(use_enable zlib compression) \
		$(use_enable tcmalloc) \
		${myconf} \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README || die

	find "${D}" -name '*.la' -delete || die
}
