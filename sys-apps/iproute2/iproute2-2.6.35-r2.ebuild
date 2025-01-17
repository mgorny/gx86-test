# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit eutils multilib toolchain-funcs flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git"
	inherit git
	SRC_URI=""
	#KEYWORDS=""
else
	if [[ ${PV} == *.*.*.* ]] ; then
		MY_PV=${PV%.*}-${PV##*.}
	else
		MY_PV=${PV}
	fi
	MY_P="${PN}-${MY_PV}"
	SRC_URI="http://developer.osdl.org/dev/iproute2/download/${MY_P}.tar.bz2"
	KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="kernel routing and traffic control utilities"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2"

LICENSE="GPL-2"
SLOT="0"
IUSE="atm berkdb ipv6 minimal"

RDEPEND="!net-misc/arpd
	!minimal? ( berkdb? ( sys-libs/db ) )
	atm? ( net-dialup/linux-atm )"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.7 )
	sys-devel/bison
	sys-devel/flex
	>=sys-kernel/linux-headers-2.6.27"

src_prepare() {
	sed -i \
		-e "/^LIBDIR/s:=.*:=/$(get_libdir):" \
		-e "s:-O2:${CFLAGS} ${CPPFLAGS}:" \
		Makefile || die

	# build against system headers
	rm -r include/netinet #include/linux include/ip{,6}tables{,_common}.h include/libiptc

	epatch "${FILESDIR}"/${PN}-2.6.29.1-hfsc.patch #291907
	epatch "${FILESDIR}"/${P}-cached-routes.patch #331447
	use ipv6 || epatch "${FILESDIR}"/${PN}-2.6.35-no-ipv6.patch #326849

	epatch_user

	# don't build arpd if USE=-berkdb #81660
	use berkdb || sed -i '/^TARGETS=/s: arpd : :' misc/Makefile

	use minimal && sed -i -e '/^SUBDIRS=/s:=.*:=lib tc:' Makefile
}

src_configure() {
	echo -n 'TC_CONFIG_ATM:=' > Config
	use atm \
		&& echo 'y' >> Config \
		|| echo 'n' >> Config

	# Use correct iptables dir, #144265 #293709
	append-cppflags -DIPT_LIB_DIR=\\\"`$(tc-getPKG_CONFIG) xtables --variable=xtlibdir`\\\"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		AR="$(tc-getAR)" \
		|| die
}

src_install() {
	if use minimal ; then
		into /
		dosbin tc/tc || die "minimal"
		return 0
	fi

	emake \
		DESTDIR="${D}" \
		SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/${PF} \
		MANDIR=/usr/share/man \
		install \
		|| die
	prepalldocs

	dolib.a lib/libnetlink.a || die
	insinto /usr/include
	doins include/libnetlink.h || die

	if use berkdb ; then
		dodir /var/lib/arpd
		# bug 47482, arpd doesn't need to be in /sbin
		dodir /usr/sbin
		mv "${D}"/sbin/arpd "${D}"/usr/sbin/
	fi
}
