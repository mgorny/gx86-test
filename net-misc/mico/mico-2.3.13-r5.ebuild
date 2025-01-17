# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs autotools

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
SRC_URI="http://www.mico.org/${P}.tar.gz"

PATCH_VER=0.2

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~ppc-aix ~ia64-hpux ~amd64-linux ~x86-linux ~sparc-solaris ~x86-winnt"
IUSE="gtk postgres qt4 ssl tcl threads X"
RESTRICT="test" #298101

[[ -z ${PATCH_VER} ]] || \
	SRC_URI="${SRC_URI} http://dev.gentoo.org/~haubi/distfiles/${P}-gentoo-patches-${PATCH_VER}.tar.bz2"

# doesn't compile:
#   bluetooth? ( net-wireless/bluez )

RDEPEND="
	gtk?       ( x11-libs/gtk+:2 )
	postgres?  ( dev-db/postgresql-base )
	qt4?       ( dev-qt/qtgui:4[qt3support] )
	ssl?       ( dev-libs/openssl )
	tcl?       ( dev-lang/tcl )
	X?         ( x11-libs/libXt )
"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.2
	>=sys-devel/bison-1.22
"

S=${WORKDIR}/${PN}

src_prepare() {
	EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patches

	eautoreconf

	# cannot use big TOC (AIX only), gdb doesn't like it.
	# This assumes that the compiler (or -wrapper) uses
	# gcc flag '-mminimal-toc' for compilation.
	sed -i -e 's/,-bbigtoc//' "${S}"/configure

	if use qt4; then
		sed -i -e "s, -lqt\", $(pkg-config --libs Qt3Support)\"," configure ||
			die "cannot update to use Qt3Support of qt4"
	fi
}

src_configure() {
	tc-export CC CXX

	if use gtk; then
		# need gtk-1 wrapper for gtk-2
		export PATH="${WORKDIR}"/helpers:${PATH}
	fi

	# Don't know which version of JavaCUP would suffice, but there is no
	# configure argument to disable checking for JavaCUP.
	# So we override the configure check to not find 'javac'.
	export ac_cv_path_JAVAC=no

	# '--without-ssl' just does not add another search path - the only way
	# to disable openssl utilization seems to override the configure check.
	use ssl || export ac_cv_lib_ssl_open=no

	# CFLAGS aren't used when checking for <qapplication.h>, but CPPFLAGS are.
	use qt4 && append-cppflags $(pkg-config --cflags Qt3Support)

	local myconf=
	myconf() {
		myconf="${myconf} $*"
	}

	myconf --disable-mini-stl
	myconf $(use_enable threads)

	# '--without-*' or '--with-*=no' does not disable some features,
	# the value needs to be empty instead.
	# This applies to: gtk, pgsql, qt, tcl, bluetooth.
	myconf --with-gtk=$(  use gtk      && echo "${EPREFIX}"/usr)
	myconf --with-pgsql=$(use postgres && echo "${EPREFIX}"/usr)
	myconf --with-qt=$(   use qt4      && echo "${EPREFIX}"/usr)
	myconf --with-tcl=$(  use tcl      && echo "${EPREFIX}"/usr)
	# bluetooth and wireless both don't compile cleanly
	myconf --with-bluetooth=''
	myconf --disable-wireless
	# But --without-x works.
	myconf $(use_with X x "${EPREFIX}"/usr)

	# http://www.mico.org/pipermail/mico-devel/2009-April/010285.html
	[[ ${CHOST} == *-hpux* ]] && append-cppflags -D_XOPEN_SOURCE_EXTENDED

	if [[ ${CHOST} == *-winnt* ]]; then
		# disabling static libs, since ar on interix takes nearly
		# one hour per library, thanks to mico's monster objects.
		use threads &&
		ewarn "disabling USE='threads', does not work on ${CHOST}"
		myconf --disable-threads --disable-static --enable-final
		append-flags -D__STDC__
	fi

	econf ${myconf}
}

src_install() {
	emake INSTDIR="${ED}"usr SHARED_INSTDIR="${ED}"usr install LDCONFIG=: || die "install failed"

	dodir /usr/share || die
	mv "${ED}"usr/man "${ED}"usr/share || die
	dodir /usr/share/doc/${PF} || die
	mv "${ED}"usr/doc "${ED}"usr/share/doc/${PF} || die

	dodoc BUGS CHANGES* CONVERT FAQ README* ROADMAP TODO VERSION WTODO || die
}
