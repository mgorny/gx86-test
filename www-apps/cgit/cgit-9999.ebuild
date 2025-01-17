# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

WEBAPP_MANUAL_SLOT="yes"

inherit webapp eutils multilib user toolchain-funcs git-2

[[ -z "${CGIT_CACHEDIR}" ]] && CGIT_CACHEDIR="/var/cache/${PN}/"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="http://git.zx2c4.com/cgit/about"
SRC_URI=""
EGIT_REPO_URI="git://git.zx2c4.com/cgit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +highlight +lua +jit"

RDEPEND="
	dev-vcs/git
	sys-libs/zlib
	dev-libs/openssl:0
	virtual/httpd-cgi
	highlight? ( || ( dev-python/pygments app-text/highlight ) )
	lua? ( jit? ( dev-lang/luajit ) !jit? ( dev-lang/lua ) )
"
# ebuilds without WEBAPP_MANUAL_SLOT="yes" are broken
DEPEND="${RDEPEND}
	!<www-apps/cgit-0.8.3.3
	doc? ( app-text/docbook-xsl-stylesheets
		>=app-text/asciidoc-8.5.1 )
"

pkg_setup() {
	webapp_pkg_setup
	enewuser "${PN}"
}

src_prepare() {
	git submodule init || die
	git submodule update || die

	echo "prefix = ${EPREFIX}/usr" >> cgit.conf
	echo "libdir = ${EPREFIX}/usr/$(get_libdir)" >> cgit.conf
	echo "CGIT_SCRIPT_PATH = ${MY_CGIBINDIR}" >> cgit.conf
	echo "CGIT_DATA_PATH = ${MY_HTDOCSDIR}" >> cgit.conf
	echo "CACHE_ROOT = ${CGIT_CACHEDIR}" >> cgit.conf
	echo "DESTDIR = ${D}" >> cgit.conf
	if use lua; then
		if use jit; then
			echo "LUA_PKGCONFIG = luajit" >> cgit.conf
		else
			echo "LUA_PKGCONFIG = lua" >> cgit.conf
		fi
	else
		echo "NO_LUA = 1" >> cgit.conf
	fi
}

src_compile() {
	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	use doc && emake V=1 doc-man
}

src_install() {
	webapp_src_preinst

	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" install

	insinto /etc
	doins "${FILESDIR}"/cgitrc

	dodoc README
	use doc && doman cgitrc.5

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	keepdir "${CGIT_CACHEDIR}"
	fowners ${PN}:${PN} "${CGIT_CACHEDIR}"
	fperms 700 "${CGIT_CACHEDIR}"
}

pkg_postinst() {
	webapp_pkg_postinst
	ewarn "If you intend to run cgit using web server's user"
	ewarn "you should change ${CGIT_CACHEDIR} permissions."
}
