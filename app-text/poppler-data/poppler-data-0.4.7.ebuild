# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="Data files for poppler to support uncommon encodings without xpdfrc"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="BSD GPL-2 MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

src_install() {
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install

	# bug 409361
	dodir /usr/share/poppler/cMaps
	cd "${D}/${EPREFIX}"/usr/share/poppler/cMaps || die
	find ../cMap -type f -exec ln -s {} . \; || die
}
