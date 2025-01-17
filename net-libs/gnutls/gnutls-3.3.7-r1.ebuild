# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools libtool eutils multilib-minimal versionator

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="mirror://gnupg/gnutls/v$(get_version_component_range 1-2)/${P}.tar.xz"

# LGPL-3 for libgnutls library and GPL-3 for libgnutls-extra library.
# soon to be relicensed as LGPL-2.1 unless heartbeat extension enabled.
LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE_LINGUAS=" en cs de fi fr it ms nl pl sv uk vi zh_CN"
IUSE="+cxx +crywrap dane doc examples guile nls pkcs11 static-libs test zlib ${IUSE_LINGUAS// / linguas_}"
# heartbeat support is not disabled until re-licensing happens fullyf

# NOTICE: sys-devel/autogen is required at runtime as we
# use system libopts
RDEPEND=">=dev-libs/libtasn1-3.4[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-2.7[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}]
	sys-devel/autogen
	crywrap? ( net-dns/libidn )
	dane? ( >=net-dns/unbound-1.4.20[${MULTILIB_USEDEP}] )
	guile? ( >=dev-scheme/guile-1.8[networking] )
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.19.3[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.11.6
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=sys-apps/texinfo-5.2
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test? ( app-misc/datefudge )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS doc/TODO )

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

src_prepare() {
	sed -i \
		-e 's/imagesdir = $(infodir)/imagesdir = $(htmldir)/' \
		doc/Makefile.am || die

	# force regeneration of autogen-ed files
	local file
	for file in $(grep -l AutoGen-ed src/*.c) ; do
		rm src/$(basename ${file} .c).{c,h} || die
	done

	# force regeneration of makeinfo files
	# have no idea why on some system these files are not
	# accepted as-is, see bug#520818
	for file in $(grep -l "produced by makeinfo" doc/*.info) ; do
		rm "${file}" || die
	done

	epatch "${FILESDIR}/${P}-build.patch"

	# support user patches
	epatch_user

	eautoreconf

	# Use sane .so versioning on FreeBSD.
	elibtoolize

	# bug 497472
	use cxx || epunt_cxx
}

multilib_src_configure() {
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	# TPM needs to be tested before being enabled
	# hardware-accell is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	ECONF_SOURCE=${S} \
	econf \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--disable-valgrind-tests \
		--enable-heartbeat-support \
		$(use_enable cxx) \
		$(use_enable dane libdane) \
		$(multilib_native_use_enable doc gtk-doc) \
		$(multilib_native_use_enable doc gtk-doc-pdf) \
		$(multilib_native_use_enable guile) \
		$(multilib_native_use_enable crywrap) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with pkcs11 p11-kit) \
		$(use_with zlib) \
		--without-tpm \
		--with-unbound-root-key-file=/etc/dnssec/root-anchors.txt \
		$([[ ${CHOST} == *-darwin* ]] && echo --disable-hardware-acceleration)
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default

		# symlink certtool for use in other ABIs
		if use test; then
			ln -s "${BUILD_DIR}"/src "${T}"/native-tools || die
		fi
	else
		emake -C gl
		emake -C lib
		emake -C extra
		use dane && emake -C libdane
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		# parallel testing often fails
		emake -j1 check
	else
		# use native ABI tools
		ln -s "${T}"/native-tools/{certtool,gnutls-{serv,cli}} \
			"${BUILD_DIR}"/src/ || die

		emake -C gl -j1 check
		emake -C tests -j1 check
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake -C lib DESTDIR="${D}" install
		emake -C extra DESTDIR="${D}" install
		use dane && emake -C libdane DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	dodoc doc/certtool.cfg

	if use doc; then
		dodoc doc/gnutls.pdf
		dohtml doc/gnutls.html
	else
		rm -fr "${ED}/usr/share/doc/${PF}/html"
	fi

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
