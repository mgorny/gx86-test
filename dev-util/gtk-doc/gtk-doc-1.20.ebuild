# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils elisp-common gnome2 python-single-r1 readme.gentoo

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="http://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="debug doc emacs highlight vim test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# dev-tex/tex4ht blocker needed due bug #315287
RDEPEND="
	>=dev-libs/glib-2.6:2
	>=dev-lang/perl-5.6
	>=app-text/openjade-1.3.1
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6:2
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( virtual/emacs )
	highlight? (
		vim? ( || ( app-editors/vim app-editors/gvim ) )
		!vim? ( dev-util/source-highlight )
	)
	!!<dev-tex/tex4ht-20090611_p1038-r1
"
DEPEND="${RDEPEND}
	~dev-util/gtk-doc-am-${PV}
	app-text/yelp-tools
	>=app-text/scrollkeeper-0.3.14
	virtual/pkgconfig
	test? ( app-text/scrollkeeper-dtd )
"

pkg_setup() {
	DOC_CONTENTS="gtk-doc does no longer define global key bindings for Emacs.
		You may set your own key bindings for \"gtk-doc-insert\" and
		\"gtk-doc-insert-section\" in your ~/.emacs file."
	SITEFILE=61${PN}-gentoo.el
	python-single-r1_pkg_setup
}

src_prepare() {
	# Always disable fop; it is unreliable enough that gtk-doc upstream
	# commented it out by default, and if it's autodetected, it causes build
	# failures in other packages, bug #403165
	sed -e 's:test -n "@FOP@":test -n "":' \
		-i gtkdoc-mkpdf.in || die "sed failed"

	# Remove global Emacs keybindings.
	epatch "${FILESDIR}/${PN}-1.8-emacs-keybindings.patch"

	gnome2_src_prepare
}

src_configure() {
	if use vim; then
		G2CONF="${G2CONF} $(use_with highlight highlight vim)"
	else
		G2CONF="${G2CONF} $(use_with highlight highlight source-highlight)"
	fi

	gnome2_src_configure --with-xml-catalog="${EPREFIX}/etc/xml/catalog"
}

src_compile() {
	gnome2_src_compile
	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	python_fix_shebang "${ED}"/usr/bin/gtkdoc-depscan

	# Don't install those files, they are in gtk-doc-am now
	rm "${ED}"/usr/share/aclocal/gtk-doc.m4 || die "failed to remove gtk-doc.m4"
	rm "${ED}"/usr/bin/gtkdoc-rebase || die "failed to remove gtkdoc-rebase"

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		readme.gentoo_create_doc
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
