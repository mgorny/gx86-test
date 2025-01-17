# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils flag-o-matic multilib toolchain-funcs

MY_PV=${PV//./}
SRC_URI="http://www.cs.arizona.edu/icon/ftp/packages/unix/icon.v${MY_PV}src.tgz"
HOMEPAGE="http://www.cs.arizona.edu/icon/"
DESCRIPTION="very high level language"

LICENSE="public-domain HPND"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="X iplsrc"

S="${WORKDIR}/icon.v${MY_PV}src"

DEPEND="X? ( x11-proto/xextproto
			x11-proto/xproto
			x11-libs/libX11
			x11-libs/libXpm
			x11-libs/libXt )
	sys-devel/gcc"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-flags.patch

	# Patch the tests so that they do not fail
	# The following files in tests/standard are patched..
	# io.icn - change /etc/motd to /etc/gentoo-release
	# io.std - change /etc/motd to /etc/gentoo-release
	# kwds.std - add two lines for the two new added keywords
	# nargs.std - a couple of functions picked up additional parameters
	epatch "${FILESDIR}/tests-${MY_PV}.patch"

	# do not prestrip files
	find "${S}"/src -name 'Makefile' | xargs sed -i -e "/strip/d" || die
}

src_compile() {
	# select the right compile target.  Note there are many platforms
	# available
	local mytarget;
	if [[ ${CHOST} == *-darwin* ]]; then
		mytarget="macintosh"
	else
		mytarget="linux"
	fi

	if use X; then
		emake X-Configure name=${mytarget} -j1 || die
	else
		emake Configure name=${mytarget} -j1 || die
	fi

	echo "#define MultiThread 1" >> src/h/define.h
	echo "#define EventMon 1" >> src/h/define.h
	echo "#define Eve 1" >> src/h/define.h

	append-flags $(test-flags -fno-strict-aliasing -fwrapv)

	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "Make Failed"
}

src_test() {
	make Samples || die "Samples failed"
	make Test || die "Test failed"
}

src_install() {
	dodir /usr
	dodir /usr/bin
	dodir /usr/$(get_libdir)

	make Install dest="${D}/usr/$(get_libdir)/icon" || die "Make install failed"
	dosym /usr/$(get_libdir)/icon/bin/icont /usr/bin/icont
	dosym /usr/$(get_libdir)/icon/bin/iconx /usr/bin/iconx
	dosym /usr/$(get_libdir)/icon/bin/icon  /usr/bin/icon
	dosym /usr/$(get_libdir)/icon/bin/vib   /usr/bin/vib

	cd "${S}/man/man1"
	doman icont.1
	doman icon.1
	rm -rf "${D}"/usr/$(get_libdir)/icon/man

	cd "${S}/doc"
	dodoc *.txt *.sed ../README
	# dohtml ignores all anything except .html files, no use here
	mkdir -p "${D}"/usr/share/doc/${PF}/html
	cp -dpR *.htm *.gif *.jpg *.css "${D}"/usr/share/doc/${PF}/html
	rm -rf "${D}"/usr/$(get_libdir)/icon/{doc,README}

	# optional Icon Programming Library
	if use iplsrc; then
		cd "${S}"
		dodir /usr/$(get_libdir)/icon/ipl
		rm ipl/BuildBin
		rm ipl/BuildExe
		rm ipl/CheckAll
		rm ipl/Makefile
		insinto /usr/$(get_libdir)/icon
		doins -r ipl
	fi
}
