# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="Pure Tcl implementation of an XML parser"
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"

IUSE="expat threads xml"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc sparc x86"

DEPEND=">=dev-lang/tcl-8.2
	>=dev-tcltk/tcllib-1.2
	xml? ( >=dev-libs/libxml2-2.6.9 )
	expat? ( dev-libs/expat )"
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-3_configure.patch
	epatch "${FILESDIR}"/${PN}-3_include_path.patch
}

src_compile() {
	local myconf=""

	use threads && myconf="${myconf} --enable-threads"

	econf ${myconf}
	emake || die

	if use xml ; then
		cd "${S}"/libxml2
		econf ${myconf} --with-Tclxml=..
		emake || die
	fi
	if use expat ; then
		cd "${S}"/expat
		econf ${myconf} --with-Tclxml=..
		emake || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use xml ; then
		cd "${S}"/libxml2
		emake DESTDIR="${D}" install || die
	fi
	if use expat ; then
		cd "${S}"/expat
		emake DESTDIR="${D}" install || die
	fi

	cd "${S}"
	dodoc ANNOUNCE ChangeLog README RELNOTES || die
	dohtml doc/*.html || die
}
