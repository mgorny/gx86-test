# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit flag-o-matic eutils multilib versionator toolchain-funcs

PATCHLEVEL="5"
MY_P="${P/_/+}"
DESCRIPTION="Fast modern type-inferring functional programming language descended from the ML family"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="ftp://ftp.inria.fr/INRIA/Projects/cristal/ocaml/ocaml-$(get_version_component_range 1-2)/${MY_P}.tar.bz2
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="QPL-1.0 LGPL-2"
# Everytime ocaml is updated to a new version, everything ocaml must be rebuilt,
# so here we go with the subslot.
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="emacs latex ncurses +ocamlopt tk X xemacs"

RDEPEND="tk? ( >=dev-lang/tk-3.3.3 )
	ncurses? ( sys-libs/ncurses )
	X? ( x11-libs/libX11 x11-proto/xproto )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PDEPEND="emacs? ( app-emacs/ocaml-mode )
	xemacs? ( app-xemacs/ocaml )"

S="${WORKDIR}/${MY_P}"
pkg_setup() {
	# dev-lang/ocaml creates its own objects but calls gcc for linking, which will
	# results in relocations if gcc wants to create a PIE executable
	if gcc-specs-pie ; then
		append-ldflags -nopie
		ewarn "Ocaml generates its own native asm, you're using a PIE compiler"
		ewarn "We have appended -nopie to ocaml build options"
		ewarn "because linking an executable with pie while the objects are not pic will not work"
	fi
}

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	# Bug #459512
	epatch "${FILESDIR}/${PN}-4.01.0-pkg-config-ncurses.patch"
}

src_configure() {
	export LC_ALL=C
	local myconf=""

	# Causes build failures because it builds some programs with -pg,
	# bug #270920
	filter-flags -fomit-frame-pointer
	# Bug #285993
	filter-mfpmath sse

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	use tk || myconf="${myconf} -no-tk"
	use ncurses || myconf="${myconf} -no-curses"
	use X || myconf="${myconf} -no-graph"

	# ocaml uses a home-brewn configure script, preventing it to use econf.
	RAW_LDFLAGS="$(raw-ldflags)" ./configure -prefix /usr \
		--bindir /usr/bin \
		--libdir /usr/$(get_libdir)/ocaml \
		--mandir /usr/share/man \
		-host "${CHOST}" \
		-cc "$(tc-getCC)" \
		-as "$(tc-getAS)" \
		-aspp "$(tc-getCC) -c" \
		-partialld "$(tc-getLD) -r" \
		--with-pthread ${myconf} || die "configure failed!"

	# http://caml.inria.fr/mantis/view.php?id=4698
	export CCLINKFLAGS="${LDFLAGS}"
}

src_compile() {
	emake -j1 world

	# Native code generation can be disabled now
	if use ocamlopt ; then
		# bug #279968
		emake -j1 opt
		emake -j1 opt.opt
	fi
}

src_install() {
	make BINDIR="${D}"/usr/bin \
		LIBDIR="${D}"/usr/$(get_libdir)/ocaml \
		MANDIR="${D}"/usr/share/man \
		install

	# Symlink the headers to the right place
	dodir /usr/include
	dosym /usr/$(get_libdir)/ocaml/caml /usr/include/caml

	dodoc Changes INSTALL README Upgrading

	# Create and envd entry for latex input files
	if use latex ; then
		echo "TEXINPUTS=/usr/$(get_libdir)/ocaml/ocamldoc:" > "${T}"/99ocamldoc
		doenvd "${T}"/99ocamldoc
	fi

	# Install ocaml-rebuild portage set
	insinto /usr/share/portage/config/sets
	doins "${FILESDIR}/ocaml.conf"
}

pkg_postinst() {
	echo
	ewarn "OCaml is not binary compatible from version to version, so you"
	ewarn "need to rebuild all packages depending on it, that are actually"
	ewarn "installed on your system. To do so, you can run:"
	if has_version '>=sys-apps/portage-2.2' ; then
		ewarn "emerge @ocaml-rebuild"
	else
		ewarn "emerge -1 /usr/$(get_libdir)/ocaml"
	fi
	echo
}
