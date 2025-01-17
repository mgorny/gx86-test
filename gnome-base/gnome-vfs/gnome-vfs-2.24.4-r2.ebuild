# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib-minimal virtualx

DESCRIPTION="Gnome Virtual Filesystem"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="acl avahi doc fam gnutls ipv6 kerberos samba ssl"

RDEPEND=">=gnome-base/gconf-2.32.4-r1[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	gnome-base/gnome-mime-data
	>=x11-misc/shared-mime-info-0.14
	>=dev-libs/dbus-glib-0.100.2[${MULTILIB_USEDEP}]
	acl? (
		>=sys-apps/acl-2.2.52-r1[${MULTILIB_USEDEP}]
		>=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] )
	avahi? ( >=net-dns/avahi-0.6.31-r2[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
	samba? ( >=net-fs/samba-3.6.23-r1[${MULTILIB_USEDEP}] )
	ssl? (
		gnutls?	(
			>=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}]
			!gnome-extra/gnome-vfs-sftp )
		!gnutls? (
			>=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}]
			!gnome-extra/gnome-vfs-sftp ) )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	>=dev-util/intltool-0.40
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=dev-util/gtk-doc-am-1.13
	doc? ( >=dev-util/gtk-doc-1 )"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r1
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"

src_prepare() {
	# Allow the Trash on afs filesystems (#106118)
	epatch "${FILESDIR}"/${PN}-2.12.0-afs.patch

	# Fix compiling with headers missing
	epatch "${FILESDIR}"/${PN}-2.15.2-headers-define.patch

	# Fix for crashes running programs via sudo
	epatch "${FILESDIR}"/${PN}-2.16.0-no-dbus-crash.patch

	# Fix automagic dependencies, upstream bug #493475
	epatch "${FILESDIR}"/${PN}-2.20.0-automagic-deps.patch
	epatch "${FILESDIR}"/${PN}-2.20.1-automagic-deps.patch

	# Fix to identify ${HOME} (#200897)
	# thanks to debian folks
	epatch "${FILESDIR}"/${PN}-2.24.4-home_dir_fakeroot.patch

	# Configure with gnutls-2.7, bug #253729
	# Fix building with gnutls-2.12, bug #388895
	epatch "${FILESDIR}"/${PN}-2.24.4-gnutls27.patch

	# Prevent duplicated volumes, bug #193083
	epatch "${FILESDIR}"/${PN}-2.24.0-uuid-mount.patch

	# Do not build tests with FEATURES="-test", bug #226221
	epatch "${FILESDIR}"/${PN}-2.24.4-build-tests-asneeded.patch

	# Disable broken test, bug #285706
	epatch "${FILESDIR}"/${PN}-2.24.4-disable-test-async-cancel.patch

	# Fix for automake-1.13 compatibility, #466944
	epatch "${FILESDIR}"/${P}-automake-1.13.patch

	# Fix deprecated API disabling in used libraries - this is not future-proof, bug 212163
	# upstream bug #519632
	sed -i -e '/DISABLE_DEPRECATED/d' \
		daemon/Makefile.am daemon/Makefile.in \
		libgnomevfs/Makefile.am libgnomevfs/Makefile.in \
		modules/Makefile.am modules/Makefile.in \
		test/Makefile.am test/Makefile.in || die
	sed -i -e 's:-DG_DISABLE_DEPRECATED:$(NULL):g' \
		programs/Makefile.am programs/Makefile.in || die

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die

	eautoreconf

	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=(
		--disable-schemas-install
		--disable-static
		--disable-cdda
		--disable-howl
		$(use_enable acl)
		$(use_enable avahi)
		$(use_enable fam)
		$(use_enable gnutls)
		--disable-hal
		$(use_enable ipv6)
		$(use_enable kerberos krb5)
		$(use_enable samba)
		$(use_enable ssl openssl)
		# Useless ? --enable-http-neon

		# fix path to krb5-config
		KRB5_CONFIG=/usr/bin/${CHOST}-krb5-config
	)

	# this works because of the order of configure parsing
	# so should always be behind the use_enable options
	# foser <foser@gentoo.org 19 Apr 2004
	use gnutls && use ssl && myconf+=( --disable-openssl )

	#bug #519060
	#configure script is so messed up on res_init on Darwin
	[[ ${CHOST} == *-darwin* ]] && export LIBS="${LIBS} -lresolv"

	ECONF_SOURCE=${S} \
	gnome2_src_configure "${myconf[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_test() {
	unset DISPLAY
	# Fix bug #285706
	unset XAUTHORITY
	Xemake check || die "tests failed"
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"
	einstalldocs
}
