# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils flag-o-matic

MY_PV=${PV}-1

DESCRIPTION="research tool for polyhedral geometry and combinatorics"
SRC_URI="http://polymake.org/lib/exe/fetch.php/download/${PN}-${MY_PV}.tar.bz2"
HOMEPAGE="http://polymake.org"

IUSE="libpolymake"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-libs/gmp
	dev-libs/boost
	dev-libs/libxml2:2
	dev-perl/XML-LibXML
	dev-libs/libxslt
	dev-perl/XML-LibXSLT
	dev-perl/XML-Writer
	dev-perl/Term-ReadLine-Gnu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# Don't strip
	sed -i '/system "strip $to"/d' support/install.pl || die

	einfo "During compile this package uses up to"
	einfo "750MB of RAM per process. Use MAKEOPTS=\"-j1\" if"
	einfo "you run into trouble."
}

src_configure () {
	export CXXOPT=$(get-flag -O)
	# Configure does not accept --host, therefore econf cannot be used
	./configure --prefix="${EPREFIX}/usr" \
		--without-java \
		$(use_with libpolymake callable) \
		--without-prereq \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/polymake" \
		"${myconf}" || die
}

src_install(){
	emake -j1 DESTDIR="${D}" install
	dosym libpolymake.so "${EPREFIX}/usr/$(get_libdir)/libpolymake.so.0"
}

pkg_postinst(){
	elog "Docs can be found on http://www.polymake.org/doku.php/documentation"
	elog " "
	elog "Support for jreality is missing, sorry (see bug #346073)."
}
