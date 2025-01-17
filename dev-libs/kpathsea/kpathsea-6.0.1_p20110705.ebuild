# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

inherit texlive-common eutils

TEXMFD_VERSION="3"

DESCRIPTION="Library implementing generic path searching, configuration, and TeX-specific file searching"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz
	mirror://gentoo/${PN}-texmf.d-${TEXMFD_VERSION}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source static-libs"

DEPEND="!<app-text/texlive-core-2010
	!app-text/ptex"
RDEPEND="${DEPEND}"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

TL_VERSION=2011
EXTRA_TL_MODULES="kpathsea"
EXTRA_TL_DOC_MODULES="kpathsea.doc"

for i in ${EXTRA_TL_MODULES} ; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${TL_VERSION}.tar.xz"
done

SRC_URI="${SRC_URI} doc? ( "
for i in ${EXTRA_TL_DOC_MODULES} ; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${TL_VERSION}.tar.xz"
done
SRC_URI="${SRC_URI} ) "

src_prepare() {
	epatch "${FILESDIR}/invocname.patch"
}

src_configure() {
	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #347798
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C

	# Disable largefile because it seems to cause problems on big endian 32 bits
	# systems...
	econf \
		--disable-largefile \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" web2cdir="${EPREFIX}/usr/share/texmf/web2c" install || die
	find "${D}" -name '*.la' -delete

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi

	# The default configuration expects it to be world writable, bug #266680
	# People can still change it with texconfig though.
	dodir /var/cache/fonts
	fperms 1777 /var/cache/fonts

	# Take care of fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{fmtutil.d,texmf.d}

	# Remove default texmf.cnf to ship our own, greatly based on texlive dvd's
	# texmf.cnf
	# It will also be generated from /etc/texmf/texmf.d files by texmf-update
	rm -f "${ED}${TEXMF_PATH}/web2c/texmf.cnf"

	insinto /etc/texmf/texmf.d
	doins "${WORKDIR}/texmf.d/"*.cnf || die "failed to install texmf.d configuration files"

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${ED}${TEXMF_PATH}/web2c/fmtutil.cnf"

	dosym /etc/texmf/web2c/fmtutil.cnf ${TEXMF_PATH}/web2c/fmtutil.cnf
	dosym /etc/texmf/web2c/texmf.cnf ${TEXMF_PATH}/web2c/texmf.cnf

	# Keep it as that's where the formats will go
	keepdir /var/lib/texmf

	dodoc BUGS ChangeLog NEWS PROJECTS README || die
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
