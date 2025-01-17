# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils versionator

IUSE="gtk doc static debug threads +ocamlopt test"

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="http://www.cis.upenn.edu/~bcpierce/unison/"
LICENSE="GPL-2"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

# ocaml version so we are sure it has ocamlopt use flag
DEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt?]
	gtk? ( >=dev-ml/lablgtk-2.2 )
	test? ( || ( dev-util/ctags virtual/emacs ) )"

RDEPEND="gtk? ( >=dev-ml/lablgtk-2.2
	|| ( net-misc/x11-ssh-askpass net-misc/ssh-askpass-fullscreen ) )
	!net-misc/unison:0
	app-admin/eselect-unison"

#PDEPEND="gtk? ( media-fonts/font-schumacher-misc )"

SRC_URI="http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}.tar.gz
	doc? ( http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.pdf
		http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.html )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.27.57-as-needed.patch"
	epatch "${FILESDIR}/${PN}-mymap.patch"
}

src_compile() {
	local myconf

	if use threads; then
		myconf="$myconf THREADS=true"
	fi

	if use static; then
		myconf="$myconf STATIC=true"
	fi

	if use debug; then
		myconf="$myconf DEBUGGING=true"
	fi

	if use gtk; then
		myconf="$myconf UISTYLE=gtk2"
	else
		myconf="$myconf UISTYLE=text"
	fi

	use ocamlopt || myconf="$myconf NATIVE=false"

	# Discard cflags as it will try to pass them to ocamlc...
	emake $myconf CFLAGS="" buildexecutable || die "error making unsion"
}

src_test() {
	emake selftest ||  die "selftest failed"
}

src_install () {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	newbin unison unison-${SLOT} || die
	dodoc BUGS.txt CONTRIB INSTALL NEWS \
		  README ROADMAP.txt TODO.txt || die

	if use doc; then
		dohtml "${DISTDIR}/${P}-manual.html" || die
		dodoc "${DISTDIR}/${P}-manual.pdf" || die
	fi
	use ocamlopt || export STRIP_MASK="*/bin/*"
}

pkg_postinst() {
	elog "Unison now uses SLOTs, so you can specify servercmd=/usr/bin/unison-${SLOT}"
	elog "in your profile files to access exactly this version over ssh."
	elog "Or you can use 'eselect unison' to set the version."
}
