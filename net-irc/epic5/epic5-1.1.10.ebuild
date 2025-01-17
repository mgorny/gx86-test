# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

USE_RUBY="ruby19"
RUBY_OPTIONAL=yes
inherit autotools eutils multilib ruby-ng toolchain-funcs

DESCRIPTION="Epic5 IRC Client"
SRC_URI="ftp://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${P}.tar.bz2"
HOMEPAGE="http://epicsol.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="archive ipv6 perl tcl ruby socks5 valgrind"

RDEPEND="virtual/libiconv
	>=dev-libs/openssl-0.9.8e-r3
	>=sys-libs/ncurses-5.6-r2
	archive? ( app-arch/libarchive )
	perl? ( >=dev-lang/perl-5.8.8-r2 )
	tcl? ( dev-lang/tcl )
	socks5? ( net-proxy/dante )
	ruby? ( $(ruby_implementations_depend) )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"
REQUIRED_USE="ruby? ( $(ruby_get_use_targets) )"

S=${WORKDIR}/${P}

pkg_setup() {
	# bug #489608, bug #497080
	use ruby && ruby-ng_pkg_setup
}

# Don't use ruby-ng's separated sources support:
src_unpack() {
	default
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.2-libarchive-automagic.patch \
		"${FILESDIR}"/${P}-ruby-automagic-as-needed.patch \
		"${FILESDIR}"/${P}-tcl-automagic-as-needed.patch \
		"${FILESDIR}"/${PN}-1.1.2-perl-automagic-as-needed.patch \
		"${FILESDIR}"/${P}-without-localdir.patch \
		"${FILESDIR}"/${P}-socks5-libsocks.patch
	eautoconf
}

src_configure() {
	econf \
		--libexecdir="${EPREFIX}"/usr/lib/misc \
		$(use_with archive libarchive) \
		$(use_with ipv6) \
		$(use_with perl) \
		$(use_with ruby ruby "$(ruby_implementation_command ${USE_RUBY})") \
		$(use_with socks5) \
		$(use_with tcl tcl "${EPREFIX}"/usr/$(get_libdir)/tclConfig.sh) \
		$(use_with valgrind valgrind)
}

src_compile() {
	# parallel build failure
	emake -j1
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc BUG_FORM COPYRIGHT EPIC4-USERS-README README KNOWNBUGS VOTES

	cd "${S}"/doc || die
	docinto doc
	dodoc \
		*.txt colors EPIC* IRCII_VERSIONS missing \
		nicknames outputhelp README.SSL SILLINESS TS4
}
