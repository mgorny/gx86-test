# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit cmake-utils flag-o-matic

MY_P="${PN}${PV}"
DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org/"
SRC_URI="${HOMEPAGE}/download/${P}-src.tgz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc static-libs"

DOCS=( Announce.txt File_id.diz README.txt REGISTER.txt )

src_configure() {
	append-flags -fno-strict-aliasing
	mycmakeargs+=(
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}/html
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	# See https://bugs.gentoo.org/show_bug.cgi?id=435006
	# If qhull-2010 is installed we need to remove its include dir so
	# that it can be replaced with a symlink in this version.
	rm -rf "${ROOT}"usr/include/qhull
}

src_install() {
	cmake-utils_src_install
	# compatibility with previous installs
	dosym libqhull /usr/include/qhull
	use doc || rm -rf "${ED}"/usr/share/doc/${PF}/html
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/lib*.a
}
