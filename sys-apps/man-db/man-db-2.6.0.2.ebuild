# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils user

DESCRIPTION="a man replacement that utilizes berkdb instead of flat files"
HOMEPAGE="http://www.nongnu.org/man-db/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="berkdb +gdbm nls selinux static-libs zlib"

RDEPEND="dev-libs/libpipeline
	berkdb? ( sys-libs/db )
	gdbm? ( sys-libs/gdbm )
	!berkdb? ( !gdbm? ( sys-libs/gdbm ) )
	|| ( sys-apps/groff >=app-doc/heirloom-doctools-080407-r2 )
	selinux? ( sec-policy/selinux-mandb )
	zlib? ( sys-libs/zlib )
	!sys-apps/man"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	# Create user now as Makefile in src_install does setuid/chown
	enewgroup man 15
	enewuser man 13 -1 /usr/share/man man
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.0.2-flock.h.patch #371937
}

src_configure() {
	export ac_cv_lib_z_gzopen=$(usex zlib)
	econf \
		--with-sections="1 1p 8 2 3 3p 4 5 6 7 9 0p tcl n l p o 1x 2x 3x 4x 5x 6x 7x 8x" \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		--with-db=$(usex gdbm gdbm $(usex berkdb db gdbm))
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc README ChangeLog NEWS docs/{HACKING,TODO}
	use static-libs || find "${D}"/usr/lib* -name '*.la' -delete
}
