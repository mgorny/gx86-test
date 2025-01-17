# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit bsdmk freebsd flag-o-matic multilib toolchain-funcs eutils multibuild

DESCRIPTION="FreeBSD's base system libraries"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

# Crypto is needed to have an internal OpenSSL header
# sys is needed for libalias, probably we can just extract that instead of
# extracting the whole tarball
SRC_URI="mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${CRYPTO}.tar.bz2
		mirror://gentoo/${LIBEXEC}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${INCLUDE}.tar.bz2
		mirror://gentoo/${USBIN}.tar.bz2
		mirror://gentoo/${GNU}.tar.bz2
		build? (
			mirror://gentoo/${SYS}.tar.bz2 )
		zfs? (
			mirror://gentoo/${CDDL}.tar.bz2 )"

if [ "${CATEGORY#*cross-}" = "${CATEGORY}" ]; then
	RDEPEND="ssl? ( dev-libs/openssl )
		hesiod? ( net-dns/hesiod )
		kerberos? ( app-crypt/heimdal )
		usb? ( !dev-libs/libusb )
		zfs? ( =sys-freebsd/freebsd-cddl-${RV}* )
		>=dev-libs/expat-2.0.1
		!sys-libs/libutempter
		!sys-freebsd/freebsd-headers"
	DEPEND="${RDEPEND}
		>=sys-devel/flex-2.5.31-r2
		=sys-freebsd/freebsd-sources-${RV}*"
else
	SRC_URI="${SRC_URI}
			mirror://gentoo/${SYS}.tar.bz2"
fi

DEPEND="${DEPEND}
		userland_GNU? ( sys-apps/mtree )
		=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/lib"

export CTARGET=${CTARGET:-${CHOST}}
if [ "${CTARGET}" = "${CHOST}" -a "${CATEGORY#*cross-}" != "${CATEGORY}" ]; then
	export CTARGET=${CATEGORY/cross-}
fi

IUSE="atm bluetooth ssl hesiod ipv6 kerberos usb netware
	build crosscompile_opts_headers-only zfs
	userland_GNU userland_BSD multilib"

pkg_setup() {
	[ -c /dev/zero ] || \
		die "You forgot to mount /dev; the compiled libc would break."

	if ! use ssl && use kerberos; then
		eerror "If you want kerberos support you need to enable ssl support, too."
	fi

	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use hesiod || mymakeopts="${mymakeopts} WITHOUT_HESIOD= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= WITHOUT_GSSAPI= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "

	mymakeopts="${mymakeopts} WITHOUT_BIND= WITHOUT_BIND_LIBS= WITHOUT_SENDMAIL= WITHOUT_CLANG= "

	if [ "${CTARGET}" != "${CHOST}" ]; then
		mymakeopts="${mymakeopts} MACHINE=$(tc-arch-kernel ${CTARGET})"
		mymakeopts="${mymakeopts} MACHINE_ARCH=$(tc-arch-kernel ${CTARGET})"
	fi
}

PATCHES=(
	"${FILESDIR}/${PN}-6.0-pmc.patch"
	"${FILESDIR}/${PN}-6.0-flex-2.5.31.patch"
	"${FILESDIR}/${PN}-6.1-csu.patch"
	"${FILESDIR}/${PN}-9.0-liblink.patch"
	"${FILESDIR}/${PN}-bsdxml2expat.patch"
	"${FILESDIR}/${PN}-9.0-netware.patch"
	"${FILESDIR}/${PN}-9.0-cve-2010-2632.patch"
	"${FILESDIR}/${PN}-9.0-bluetooth.patch"
	"${FILESDIR}/${PN}-9.1-.eh_frame_hdr-fix.patch"
	)

# Here we disable and remove source which we don't need or want
# In order:
# - ncurses stuff
# - libexpat creates a bsdxml library which is the same as expat
# - archiving libraries (have their own ebuild)
# - sendmail libraries (they are installed by sendmail)
# - SNMP library and dependency (have their own ebuilds)
# - libstand: static library, 32bits on amd64 used for boot0, we build it from
# boot0 instead.
#
# The rest are libraries we already have somewhere else because
# they are contribution.
# Note: libtelnet is an internal lib used by telnet and telnetd programs
# as it's not used in freebsd-lib package itself, it's pointless building
# it here.
REMOVE_SUBDIRS="ncurses \
	libexpat \
	libz libbz2 libarchive liblzma \
	libsm libsmdb libsmutil \
	libbegemot libbsnmp \
	libpam libpcap bind libwrap libmagic \
	libcom_err libtelnet
	libelf libedit
	libstand
	libgssapi"

# For doing multilib over multibuild.eclass
MULTIBUILD_VARIANTS=( $(get_all_abis) )

# Are we building a cross-compiler?
is_crosscompile() {
	[ "${CATEGORY#*cross-}" != "${CATEGORY}" ]
}

src_prepare() {
	sed -i.bak -e 's:-o/dev/stdout:-t:' "${S}/libc/net/Makefile.inc"

	# Upstream Display Managers default to using VT7
	# We should make FreeBSD allow this by default
	local x=
	for x in "${WORKDIR}"/etc/etc.*/ttys ; do
		sed -i.bak \
			-e '/ttyv5[[:space:]]/ a\
# Display Managers default to VT7.\
# If you use the xdm init script, keep ttyv6 commented out\
# unless you force a different VT for the DM being used.' \
			-e '/^ttyv[678][[:space:]]/ s/^/# /' "${x}" \
			|| die "Failed to sed ${x}"
		rm "${x}".bak
	done

	# This one is here because it also
	# patches "${WORKDIR}/include"
	cd "${WORKDIR}"
	epatch "${FILESDIR}/${PN}-includes.patch"
	epatch "${FILESDIR}/${PN}-8.0-gcc45.patch"
	epatch "${FILESDIR}/${PN}-9.0-opieincludes.patch"
	epatch "${FILESDIR}/${PN}-9.1-aligned_alloc.patch"
	epatch "${FILESDIR}/${PN}-9.1-rmgssapi.patch"

	# Don't install the hesiod man page or header
	rm "${WORKDIR}"/include/hesiod.h || die
	sed -i.bak -e 's:hesiod.h::' "${WORKDIR}"/include/Makefile || die
	sed -i.bak -e 's:hesiod.c::' -e 's:hesiod.3::' \
	"${WORKDIR}"/lib/libc/net/Makefile.inc || die

	# Fix the Makefiles of these few libraries that will overwrite our LDADD.
	cd "${S}"
	for dir in libradius libtacplus libcam libdevstat libfetch libgeom libmemstat libopie \
		libsmb libprocstat libulog; do sed -i.bak -e 's:LDADD=:LDADD+=:g' "${dir}/Makefile" || \
		die "Problem fixing \"${dir}/Makefile"
	done
	# Call LD with LDFLAGS, rename them to RAW_LDFLAGS
	sed -e 's/LDFLAGS/RAW_LDFLAGS/g' \
		-i "${S}/csu/i386-elf/Makefile" \
		-i "${S}/csu/ia64/Makefile" || die
	if use build; then
		cd "${WORKDIR}"
		# This patch has to be applied on ${WORKDIR}/sys, so we do it here since it
		# shouldn't be a symlink to /usr/src/sys (which should be already patched)
		epatch "${FILESDIR}"/${PN}-7.1-types.h-fix.patch
		epatch "${FILESDIR}"/freebsd-sources-9.0-sysctluint.patch
		return 0
	fi

	if ! is_crosscompile ; then
		ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys" || die "Couldn't make sys symlink!"
	else
		sed -i.bak -e "s:/usr/include:/usr/${CTARGET}/usr/include:g" \
			"${S}/libc/rpc/Makefile.inc" \
			"${S}/libc/yp/Makefile.inc"
	fi

	if install --version 2> /dev/null | grep -q GNU; then
		sed -i.bak -e 's:${INSTALL} -C:${INSTALL}:' "${WORKDIR}/include/Makefile"
	fi

	# Try to fix sed calls for GNU sed. Do it only with GNU userland and force
	# BSD's sed on BSD.
	cd "${S}"
	if use userland_GNU; then
		find . -name Makefile -exec sed -ibak 's/sed -i /sed -i/' {} \;
	fi
}

get_csudir() {
	if [ -d "${WORKDIR}/lib/csu/$1-elf" ]; then
		echo "lib/csu/$1-elf"
	else
		echo "lib/csu/$1"
	fi
}

bootstrap_csu() {
	local csudir="$(get_csudir $(tc-arch-kernel ${CTARGET}))"
	export RAW_LDFLAGS=$(raw-ldflags)
	cd "${WORKDIR}/${csudir}" || die "Missing ${csudir}."
	freebsd_src_compile

	CFLAGS="${CFLAGS} -B ${MAKEOBJDIRPREFIX}/${WORKDIR}/${csudir}"
	append-ldflags "-B ${MAKEOBJDIRPREFIX}/${WORKDIR}/${csudir}"

	cd "${WORKDIR}/gnu/lib/csu" || die
	freebsd_src_compile
	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
	for i in *.So ; do
		ln -s $i ${i%.So}S.o
	done
	CFLAGS="${CFLAGS} -B ${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
	append-ldflags "-B ${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
}

# Compile libssp_nonshared.a and add it's path to LDFLAGS.
bootstrap_libssp_nonshared() {
	cd "${WORKDIR}/gnu/lib/libssp/libssp_nonshared/" || die "missing libssp."
	freebsd_src_compile
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/libssp/libssp_nonshared/"
	export LDADD="-lssp_nonshared"
}

bootstrap_libc() {
	cd "${WORKDIR}/lib/libc" || die
	freebsd_src_compile
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libc"
}

bootstrap_libgcc() {
	cd "${WORKDIR}/lib/libcompiler_rt" || die
	freebsd_src_compile
	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libcompiler_rt" || die
	ln -s libcompiler_rt.a libgcc.a || die
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libcompiler_rt"

	bootstrap_libc

	cd "${WORKDIR}/gnu/lib/libgcc" || die
	freebsd_src_compile
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/libgcc"
}

bootstrap_libthr() {
	cd "${WORKDIR}/lib/libthr" || die
	freebsd_src_compile
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libthr"
	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libthr" || die
	ln -s libthr.so libpthread.so
}

# What to build for a cross-compiler.
# We also need the csu but this has to be handled separately.
CROSS_SUBDIRS="lib/libc lib/msun gnu/lib/libssp/libssp_nonshared lib/libthr lib/libutil lib/librt"

# What to build for non-default ABIs.
NON_NATIVE_SUBDIRS="${CROSS_SUBDIRS} gnu/lib/csu lib/libcompiler_rt gnu/lib/libgcc lib/libmd lib/libcrypt"

# Subdirs for a native build:
NATIVE_SUBDIRS="lib gnu/lib/libssp/libssp_nonshared gnu/lib/libregex gnu/lib/csu gnu/lib/libgcc"

# Is my $ABI native ?
is_native_abi() {
	is_crosscompile && return 1
	use multilib || return 0
	[ "${ABI}" = "${DEFAULT_ABI}" ]
}

# Do we need to bootstrap the csu and libssp_nonshared?
need_bootstrap() {
	is_crosscompile || use build || { ! is_native_abi && ! has_version '>=sys-freebsd/freebsd-lib-9.1-r8[multilib]' ; } || has_version "<${CATEGORY}/${P}"
}

# Get the subdirs we are building.
get_subdirs() {
	local ret=""
	if is_native_abi ; then
		# If we are building for the native ABI, build everything
		ret="${NATIVE_SUBDIRS}"
	elif is_crosscompile ; then
		# With a cross-compiler we only build the very core parts.
		ret="${CROSS_SUBDIRS}"
		if [ "${EBUILD_PHASE}" = "install" ]; then
			# Add the csu dir first when installing. We treat it separately for
			# compiling.
			ret="$(get_csudir $(tc-arch-kernel ${CTARGET})) ${ret}"
		fi
	else
		# For the non-native ABIs we only build the csu parts and very core
		# libraries for now.
		ret="${NON_NATIVE_SUBDIRS} $(get_csudir $(tc-arch-kernel ${CHOST}))"
	fi
	echo "${ret}"
}

# Bootstrap the core libraries and setup the flags so that the other parts can
# build against it.
do_bootstrap() {
	einfo "Bootstrapping on ${CHOST} for ${CTARGET}"
	if ! is_crosscompile ; then
		# Pre-install headers, but not when building a cross-compiler since we
		# assume they have been installed in the previous pass.
		einfo "Pre-installing includes in include_proper_${ABI}"
		mkdir "${WORKDIR}/include_proper_${ABI}" || die
		CTARGET="${CHOST}" install_includes "/include_proper_${ABI}"
		CFLAGS="${CFLAGS} -isystem ${WORKDIR}/include_proper_${ABI}"
	fi
	bootstrap_csu
	bootstrap_libssp_nonshared
	is_crosscompile && bootstrap_libc
	is_crosscompile || is_native_abi || bootstrap_libgcc
	is_native_abi   || bootstrap_libthr
}

# Compile it. Assume we have the toolchain setup correctly.
do_compile() {
	# Bootstrap if needed, otherwise assume the system headers are in
	# /usr/include.
	if need_bootstrap ; then
		do_bootstrap
	else
		CFLAGS="${CFLAGS} -isystem /usr/include"
	fi

	export RAW_LDFLAGS=$(raw-ldflags)

	# Everything is now setup, build it!
	for i in $(get_subdirs) ; do
		einfo "Building in ${i}... with CC=${CC} and CFLAGS=${CFLAGS}"
		cd "${WORKDIR}/${i}/" || die "missing ${i}."
		freebsd_src_compile || die "make ${i} failed"
	done
}

src_compile() {
	# Does not work with GNU sed
	# Force BSD's sed on BSD.
	if use userland_BSD ; then
		export ESED=/usr/bin/sed
		unalias sed
	fi

	cd "${WORKDIR}/include"
	$(freebsd_get_bmake) CC="$(tc-getCC)" || die "make include failed"

	use crosscompile_opts_headers-only && return 0

	# Bug #270098
	append-flags $(test-flags -fno-strict-aliasing)

	# Bug #324445
	append-flags $(test-flags -fno-strict-overflow)

	# strip flags and do not do it later, we only add safe, and in fact
	# needed flags after all
	strip-flags
	export NOFLAGSTRIP=yes
	if is_crosscompile ; then
		export YACC='yacc -by'
		CHOST=${CTARGET} tc-export CC LD CXX RANLIB
		mymakeopts="${mymakeopts} NLS="
		CFLAGS="${CFLAGS} -isystem /usr/${CTARGET}/usr/include"
		append-ldflags "-L${WORKDIR}/${CHOST}/${WORKDIR}/lib/libc"
	fi

	if is_crosscompile ; then
		do_compile
	else
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper do_compile
	fi
}

gen_libc_ldscript() {
	# Parameters:
	#   $1 = target libdir
	#   $2 = source libc dir
	#   $3 = source libssp_nonshared dir

	# Clear the symlink.
	rm -f "${D}/$2/libc.so" || die

	# Move the library if needed
	if [ "$1" != "$2" ] ; then
		mv "${D}/$2/libc.so.7" "${D}/$1/" || die
	fi

	# Generate libc.so ldscript for inclusion of libssp_nonshared.a when linking
	# this is done to avoid having to touch gcc spec file as it is currently
	# done on FreeBSD upstream, mostly because their binutils aren't able to
	# cope with linker scripts yet.
	# Taken from toolchain-funcs.eclass:
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat > "${D}/$2/libc.so" <<-END_LDSCRIPT
/* GNU ld script
   SSP (-fstack-protector) requires __stack_chk_fail_local to be local.
   GCC invokes this symbol in a non-PIC way, which results in TEXTRELs if
   this symbol was provided by a shared libc. So we link in
   libssp_nonshared.a from here.
 */
${output_format}
GROUP ( /$1/libc.so.7 /$3/libssp_nonshared.a )
END_LDSCRIPT
}

header_list=""

move_header() {
	local dirname=$(dirname ${1})
	local filename=$(basename ${1})

	if [ ! -d "${dirname}/${ABI}" ] ; then
		mkdir "${dirname}/${ABI}" || die
	fi

	mv "${1}" "${dirname}/${ABI}/" || die

	export header_list="${header_list} ${1}"
}

make_header_template() {
	cat <<-END_HEADER
/*
 * Wrapped header for multilib support.
 * See the real headers included below.
 */

#if defined(__x86_64__)
  @ABI_amd64_fbsd@
#elif defined(__i386__)
  @ABI_x86_fbsd@
#else
  @ABI_${DEFAULT_ABI}@
#endif
END_HEADER
}

wrap_header() {
	local dirname=$(dirname ${1})
	local filename=$(basename ${1})

	if [ -n "${dirname#.}" ] ; then
		dirname="${dirname}/${2}"
	else
		dirname="${2}"
	fi

	if [ -f "${dirname}/${filename}" ] ; then
		sed -e "s:@ABI_${2}@:#include <${dirname}/${filename}>:" ${1}
	else
		cat ${1}
	fi
}

wrap_header_end() {
	sed -e "s:@ABI_.*@:#error \"Sorry, no support for your ABI.\":" ${1}
}

do_install() {
	if is_crosscompile ; then
		INCLUDEDIR="/usr/${CTARGET}/usr/include"
	else
		INCLUDEDIR="/usr/include"
	fi

	dodir ${INCLUDEDIR}
	CTARGET="${CHOST}" \
		install_includes ${INCLUDEDIR}

	is_crosscompile && use crosscompile_opts_headers-only && return 0

	for i in $(get_subdirs) ; do
		einfo "Installing in ${i}..."
		cd "${WORKDIR}/${i}/" || die "missing ${i}."
		freebsd_src_install || die "Install ${i} failed"
	done

	if ! is_crosscompile ; then
		if use multilib && [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
			gen_libc_ldscript "usr/$(get_libdir)" "usr/$(get_libdir)" "usr/$(get_libdir)"
		else
			dodir "$(get_libdir)"
			gen_libc_ldscript "$(get_libdir)" "usr/$(get_libdir)" "usr/$(get_libdir)"
		fi
	else
		CHOST=${CTARGET} gen_libc_ldscript "usr/${CTARGET}/usr/lib" "usr/${CTARGET}/usr/lib" "usr/${CTARGET}/usr/lib"
	fi

	if use multilib ; then
		cd "${D}/usr/include"
		for i in machine/*.h fenv.h ; do
			move_header ${i}
		done
		if [ "${ABI}" = "${DEFAULT_ABI}" ] ; then
			# Supposedly the last one!
			local uniq_headers="$(echo ${header_list} | tr ' ' '\n' | sort | uniq | tr '\n' ' ')"
			for j in ${uniq_headers} ; do
				make_header_template > ${j}
				for i in $(get_all_abis) ; do
					wrap_header ${j} ${i} > ${j}.new
					cp ${j}.new ${j}
					rm -f ${j}.new
				done
				wrap_header_end ${j} > ${j}.new
				cp ${j}.new ${j}
				rm -f ${j}.new
			done
		fi
	fi
}

src_install() {
	if is_crosscompile ; then
		einfo "Installing for ${CTARGET} in ${CHOST}.."
		# From this point we need to force: get stripped with the correct tools,
		# get tc-arch-kernel to return the right value, etc.
		export CHOST=${CTARGET}

		mymakeopts="${mymakeopts} NO_MAN= \
			INCLUDEDIR=/usr/${CTARGET}/usr/include \
			SHLIBDIR=/usr/${CTARGET}/usr/lib \
			LIBDIR=/usr/${CTARGET}/usr/lib"

		dosym "usr/include" "/usr/${CTARGET}/sys-include"
		do_install

		return 0
	else
		export STRIP_MASK="*/usr/lib*/*crt*.o"
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper do_install
	fi

	cd "${WORKDIR}/etc/"
	insinto /etc
	doins nls.alias mac.conf netconfig

	# Install ttys file
	local MACHINE="$(tc-arch-kernel)"
	doins "etc.${MACHINE}"/*

	# Generate ldscripts for core libraries that will go in /
	gen_usr_ldscript -a alias cam geom ipsec jail kiconv \
		kvm m md procstat sbuf thr ufs util

	# Install a libusb.pc for better compat with Linux's libusb
	if use usb ; then
		dodir /usr/$(get_libdir)/pkgconfig
		sed -e "s:@LIBDIR@:/usr/$(get_libdir):" "${FILESDIR}/libusb.pc.in" > "${D}/usr/$(get_libdir)/pkgconfig/libusb.pc" || die
		sed -e "s:@LIBDIR@:/usr/$(get_libdir):" "${FILESDIR}/libusb-1.0.pc.in" > "${D}/usr/$(get_libdir)/pkgconfig/libusb-1.0.pc" || die
	fi
}

install_includes()
{
	local INCLUDEDIR="$1"

	# The idea is to be called from either install or unpack.
	# During unpack it's required to install them as portage's user.
	if [[ "${EBUILD_PHASE}" == "install" ]]; then
		local DESTDIR="${D}"
		BINOWN="root"
		BINGRP="wheel"
	else
		local DESTDIR="${WORKDIR}"
		[[ -z "${USER}" ]] && USER="portage"
		BINOWN="${USER}"
		[[ -z "${GROUPS}" ]] && GROUPS="portage"
		BINGRP="${GROUPS}"
	fi

	# Must exist before we use it.
	[[ -d "${DESTDIR}${INCLUDEDIR}" ]] || die "dodir or mkdir ${INCLUDEDIR} before using install_includes."
	cd "${WORKDIR}/include"

	local MACHINE="$(tc-arch-kernel)"

	einfo "Installing includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
	$(freebsd_get_bmake) installincludes \
		MACHINE=${MACHINE} MACHINE_ARCH=${MACHINE} \
		DESTDIR="${DESTDIR}" \
		INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
		BINGRP="${BINGRP}" || die "install_includes() failed"
	einfo "includes installed ok."
	EXTRA_INCLUDES="lib/librtld_db lib/libutil lib/msun gnu/lib/libregex"
	for i in $EXTRA_INCLUDES; do
		einfo "Installing $i includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
		cd "${WORKDIR}/$i" || die
		$(freebsd_get_bmake) installincludes DESTDIR="${DESTDIR}" \
			MACHINE=${MACHINE} MACHINE_ARCH=${MACHINE} \
			INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
			BINGRP="${BINGRP}" || die "problem installing $i includes."
		einfo "$i includes installed ok."
	done
}
