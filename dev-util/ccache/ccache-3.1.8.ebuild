# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit multilib eutils

DESCRIPTION="fast compiler cache"
HOMEPAGE="http://ccache.samba.org/"
SRC_URI="http://samba.org/ftp/ccache/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_prepare() {
	# make sure we always use system zlib
	rm -rf zlib
	epatch "${FILESDIR}"/${PN}-3.1.7-no-perl.patch #421609
	sed \
		-e "/^LIBDIR=/s:lib:$(get_libdir):" \
		"${FILESDIR}"/ccache-config > ccache-config || die
}

src_install() {
	default
	dodoc AUTHORS.txt MANUAL.txt NEWS.txt README.txt

	dobin ccache-config
}

pkg_postinst() {
	"${ROOT}"/usr/bin/ccache-config --install-links
	"${ROOT}"/usr/bin/ccache-config --install-links ${CHOST}

	# nuke broken symlinks from previous versions that shouldn't exist
	rm -f "${ROOT}/usr/$(get_libdir)/ccache/bin/${CHOST}-cc"
	[[ -d "${ROOT}/usr/$(get_libdir)/ccache.backup" ]] && \
		rm -rf "${ROOT}/usr/$(get_libdir)/ccache.backup"

	elog "To use ccache with **non-Portage** C compiling, add"
	elog "/usr/$(get_libdir)/ccache/bin to the beginning of your path, before /usr/bin."
	elog "Portage 2.0.46-r11+ will automatically take advantage of ccache with"
	elog "no additional steps.  If this is your first install of ccache, type"
	elog "something like this to set a maximum cache size of 2GB:"
	elog "# ccache -M 2G"
	elog
	elog "If you are upgrading from an older version than 3.x you should clear"
	elog "all of your caches like so:"
	elog "# CCACHE_DIR='${CCACHE_DIR:-${PORTAGE_TMPDIR}/ccache}' ccache -C"
}
