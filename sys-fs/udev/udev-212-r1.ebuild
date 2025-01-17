# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools bash-completion-r1 eutils linux-info multilib toolchain-funcs versionator multilib-minimal

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"
	inherit git-2
	patchset=
else
	patchset=1
	SRC_URI="http://www.freedesktop.org/software/systemd/systemd-${PV}.tar.xz"
	if [[ -n "${patchset}" ]]; then
				SRC_URI="${SRC_URI}
					http://dev.gentoo.org/~ssuominen/${P}-patches-${patchset}.tar.xz
					http://dev.gentoo.org/~williamh/dist/${P}-patches-${patchset}.tar.xz"
			fi
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl doc +firmware-loader gudev introspection +kmod selinux static-libs"

RESTRICT="test"

COMMON_DEPEND=">=sys-apps/util-linux-2.20
	acl? ( sys-apps/acl )
	gudev? ( >=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!<sys-libs/glibc-2.11
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
# Force new make >= -r4 to skip some parallel build issues
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	sys-libs/libcap
	virtual/os-headers
	virtual/pkgconfig
	>=sys-devel/make-3.82-r4
	>=sys-kernel/linux-headers-3.9
	doc? ( >=dev-util/gtk-doc-1.18 )"
# Try with `emerge -C docbook-xml-dtd` to see the build failure without DTDs
if [[ ${PV} = 9999* ]]; then
	DEPEND="${DEPEND}
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
		>=dev-util/intltool-0.50"
fi
RDEPEND="${COMMON_DEPEND}
	!<sys-fs/lvm2-2.02.103
	!<sec-policy/selinux-base-2.20120725-r10"
PDEPEND=">=sys-apps/hwids-20140304[udev]
	>=sys-fs/udev-init-scripts-26"

S=${WORKDIR}/systemd-${PV}

# The multilib-build.eclass doesn't handle situation where the installed headers
# are different in ABIs. In this case, we install libgudev headers in native
# ABI but not for non-native ABI.
multilib_check_headers() { :; }

check_default_rules() {
	# Make sure there are no sudden changes to upstream rules file
	# (more for my own needs than anything else ...)
	local udev_rules_md5=6bd3d421b9b6acd0e2d87ad720d6a389
	MD5=$(md5sum < "${S}"/rules/50-udev-default.rules)
	MD5=${MD5/  -/}
	if [[ ${MD5} != ${udev_rules_md5} ]]; then
		eerror "50-udev-default.rules has been updated, please validate!"
		eerror "md5sum: ${MD5}"
		die "50-udev-default.rules has been updated, please validate!"
	fi
}

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET"
	linux-info_pkg_setup

	# Based on README from tarball:
	local MINKV=3.0
	# These arch's have the mandatory accept4() function support in Linux 2.6.32*, see:
	# $ grep -r define.*accept4 linux-2.6.32*/*
	if use amd64 || use ia64 || use mips || use sparc || use x86; then
		MINKV=2.6.32
	fi

	if kernel_is -lt ${MINKV//./ }; then
		eerror "Your running kernel is too old to run this version of ${P}"
		eerror "You need to upgrade kernel at least to ${MINKV}"
	fi
}

src_prepare() {
	if ! [[ ${PV} = 9999* ]]; then
		# secure_getenv() disable for non-glibc systems wrt bug #443030
		if ! [[ $(grep -r secure_getenv * | wc -l) -eq 22 ]]; then
			eerror "The line count for secure_getenv() failed, see bug #443030"
			die
		fi
	fi

	# backport some patches
	if [[ -n "${patchset}" ]]; then
		EPATCH_SUFFIX=patch EPATCH_FORCE=yes epatch
	fi

	cat <<-EOF > "${T}"/40-gentoo.rules
	# Gentoo specific usb group
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", GROUP="usb"
	# Keep this for Linux 2.6.32 kernels with incomplete devtmpfs support because
	# accept4() function is supported for some arch's wrt #457868
	SUBSYSTEM=="mem", KERNEL=="null|zero|full|random|urandom", MODE="0666"
	EOF

	# Remove requirements for gettext and intltool wrt bug #443028
	if ! has_version dev-util/intltool && ! [[ ${PV} = 9999* ]]; then
		sed -i \
			-e '/INTLTOOL_APPLIED_VERSION=/s:=.*:=0.40.0:' \
			-e '/XML::Parser perl module is required for intltool/s|^|:|' \
			configure || die
		eval export INTLTOOL_{EXTRACT,MERGE,UPDATE}=/bin/true
		eval export {MSG{FMT,MERGE},XGETTEXT}=/bin/true
	fi

	# compile with older versions of gcc #451110
	version_is_at_least 4.6 $(gcc-version) || \
		sed -i 's:static_assert:alsdjflkasjdfa:' src/shared/macro.h

	# change rules back to group uucp instead of dialout for now wrt #454556
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die

	# apply user patches
	epatch_user

	if [[ ! -e configure ]]; then
		if use doc; then
			gtkdocize --docdir docs || die "gtkdocize failed"
		else
			echo 'EXTRA_DIST =' > docs/gtk-doc.make
		fi
		eautoreconf
	else
		check_default_rules
		elibtoolize
	fi

	# Restore possibility of running --enable-static wrt #472608
	sed -i \
		-e '/--enable-static is not supported by systemd/s:as_fn_error:echo:' \
		configure || die

	if ! use elibc_glibc; then #443030
		echo '#define secure_getenv(x) NULL' >> config.h.in
		sed -i -e '/error.*secure_getenv/s:.*:#define secure_getenv(x) NULL:' src/shared/missing.h || die
	fi
}

multilib_src_configure() {
	tc-export CC #463846
	export cc_cv_CFLAGS__flto=no #502950

	# Keep sorted by ./configure --help and only pass --disable flags
	# when *required* to avoid external deps or unnecessary compile
	local econf_args
	econf_args=(
		ac_cv_search_cap_init=
		--libdir=/usr/$(get_libdir)
		--docdir=/usr/share/doc/${PF}
		--disable-nls
		--disable-python-devel
		--disable-dbus
		--disable-seccomp
		--disable-xz
		--disable-pam
		--disable-xattr
		--disable-gcrypt
		--disable-audit
		--disable-libcryptsetup
		--disable-qrencode
		--disable-microhttpd
		--disable-gnutls
		--disable-readahead
		--disable-quotacheck
		--disable-logind
		--disable-polkit
		--disable-myhostname
		$(use_enable gudev)
		--enable-split-usr
		--with-html-dir=/usr/share/doc/${PF}/html
		--without-python
		--with-bashcompletiondir="$(get_bashcompdir)"
		--with-rootprefix=
	)
	# Use pregenerated copies when possible wrt #480924
	if ! [[ ${PV} = 9999* ]]; then
		econf_args+=(
			--disable-manpages
		)
	fi
	if multilib_is_native_abi; then
		econf_args+=(
			$(use_enable static-libs static)
			$(use_enable doc gtk-doc)
			$(use_enable introspection)
			$(use_enable acl)
			$(use_enable kmod)
			$(use_enable selinux)
			--with-rootlibdir=/$(get_libdir)
		)
	else
		econf_args+=(
			--disable-static
			--disable-gtk-doc
			--disable-introspection
			--disable-acl
			--disable-kmod
			--disable-selinux
			--disable-manpages
			--with-rootlibdir=/usr/$(get_libdir)
		)
	fi
	use firmware-loader && econf_args+=( --with-firmware-path="/lib/firmware/updates:/lib/firmware" )

	ECONF_SOURCE=${S} econf "${econf_args[@]}"
}

multilib_src_compile() {
	echo 'BUILT_SOURCES: $(BUILT_SOURCES)' > "${T}"/Makefile.extra
	emake -f Makefile -f "${T}"/Makefile.extra BUILT_SOURCES

	# Most of the parallel build problems were solved by >=sys-devel/make-3.82-r4,
	# but not everything -- separate building of the binaries as a workaround,
	# which will force internal libraries required for the helpers to be built
	# early enough, like eg. libsystemd-shared.la
	if multilib_is_native_abi; then
		local lib_targets=( libudev.la )
		use gudev && lib_targets+=( libgudev-1.0.la )
		emake "${lib_targets[@]}"

		local exec_targets=(
			systemd-udevd
			udevadm
		)
		emake "${exec_targets[@]}"

		local helper_targets=(
			ata_id
			cdrom_id
			collect
			scsi_id
			v4l_id
			accelerometer
			mtd_probe
		)
		emake "${helper_targets[@]}"

		if [[ ${PV} = 9999* ]]; then
			local man_targets=(
				man/systemd.link.5
				man/udev.7
				man/udevadm.8
				man/systemd-udevd.service.8
			)
			emake "${man_targets[@]}"
		fi

		if use doc; then
			emake -C docs/libudev
			use gudev && emake -C docs/gudev
		fi
	else
		local lib_targets=( libudev.la )
		use gudev && lib_targets+=( libgudev-1.0.la )
		emake "${lib_targets[@]}"
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		local lib_LTLIBRARIES="libudev.la" \
			pkgconfiglib_DATA="src/libudev/libudev.pc"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-libgudev_includeHEADERS
			install-rootbinPROGRAMS
			install-rootlibexecPROGRAMS
			install-udevlibexecPROGRAMS
			install-dist_udevconfDATA
			install-dist_udevrulesDATA
			install-girDATA
			install-pkgconfiglibDATA
			install-sharepkgconfigDATA
			install-typelibsDATA
			install-dist_docDATA
			libudev-install-hook
			install-directories-hook
			install-dist_bashcompletionDATA
			install-dist_networkDATA
		)

		if use gudev; then
			lib_LTLIBRARIES+=" libgudev-1.0.la"
			pkgconfiglib_DATA+=" src/gudev/gudev-1.0.pc"
		fi

		# add final values of variables:
		targets+=(
			rootlibexec_PROGRAMS=systemd-udevd
			rootbin_PROGRAMS=udevadm
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			INSTALL_DIRS='$(sysconfdir)/udev/rules.d \
					$(sysconfdir)/udev/hwdb.d \
					$(sysconfdir)/systemd/network'
			dist_bashcompletion_DATA="shell-completion/bash/udevadm"
			dist_network_DATA="network/99-default.link"
		)
		emake -j1 DESTDIR="${D}" "${targets[@]}"

		if use doc; then
			emake -C docs/libudev DESTDIR="${D}" install
			use gudev && emake -C docs/gudev DESTDIR="${D}" install
		fi

		if [[ ${PV} = 9999* ]]; then
			doman man/{systemd.link.5,udev.7,udevadm.8,systemd-udevd.service.8}
		else
			doman "${S}"/man/{systemd.link.5,udev.7,udevadm.8,systemd-udevd.service.8}
		fi
	else
		local lib_LTLIBRARIES="libudev.la" \
			pkgconfiglib_DATA="src/libudev/libudev.pc" \
			include_HEADERS="src/libudev/libudev.h"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-pkgconfiglibDATA
		)

		if use gudev; then
			lib_LTLIBRARIES+=" libgudev-1.0.la"
			pkgconfiglib_DATA+=" src/gudev/gudev-1.0.pc"
		fi

		targets+=(
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			include_HEADERS="${include_HEADERS}"
			)
		emake -j1 DESTDIR="${D}" "${targets[@]}"
	fi
}

multilib_src_install_all() {
	dodoc TODO

	prune_libtool_files --all
	rm -f \
		"${D}"/lib/udev/rules.d/99-systemd.rules \
		"${D}"/usr/share/doc/${PF}/{LICENSE.*,GVARIANT-SERIALIZATION,DIFFERENCES,PORTING-DBUS1,sd-shutdown.h}

	# see src_prepare() for content of 40-gentoo.rules
	insinto /lib/udev/rules.d
	doins "${T}"/40-gentoo.rules

	# maintainer note: by not letting the upstream build-sys create the .so
	# link, you also avoid a parallel make problem
	mv "${D}"/usr/share/man/man8/systemd-udevd{.service,}.8
}

pkg_preinst() {
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${ROOT%/}/usr/share/gtk-doc/html/${htmldir} ]]; then
			rm -rf "${ROOT%/}"/usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${D}/usr/share/doc/${PF}/html/${htmldir} ]]; then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
}

pkg_postinst() {
	mkdir -p "${ROOT%/}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${ROOT%/}"/dev/loop 2>/dev/null
	if [[ -d ${ROOT%/}/dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	local fstab="${ROOT%/}"/etc/fstab dev path fstype rest
	while read -r dev path fstype rest; do
		if [[ ${path} == /dev && ${fstype} != devtmpfs ]]; then
			ewarn "You need to edit your /dev line in ${fstab} to have devtmpfs"
			ewarn "filesystem. Otherwise udev won't be able to boot."
			ewarn "See, http://bugs.gentoo.org/453186"
		fi
	done < "${fstab}"

	if [[ -d ${ROOT%/}/usr/lib/udev ]]; then
		ewarn
		ewarn "Please re-emerge all packages on your system which install"
		ewarn "rules and helpers in /usr/lib/udev. They should now be in"
		ewarn "/lib/udev."
		ewarn
		ewarn "One way to do this is to run the following command:"
		ewarn "emerge -av1 \$(qfile -q -S -C /usr/lib/udev)"
		ewarn "Note that qfile can be found in app-portage/portage-utils"
	fi

	local old_cd_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-cd.rules
	local old_net_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-net.rules
	for old_rules in "${old_cd_rules}" "${old_net_rules}"; do
		if [[ -f ${old_rules} ]]; then
			ewarn
			ewarn "File ${old_rules} is from old udev installation but if you still use it,"
			ewarn "rename it to something else starting with 70- to silence this deprecation"
			ewarn "warning."
		fi
	done

	elog
	elog "Starting from version >= 197 the new predictable network interface names are"
	elog "used by default, see:"
	elog "http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames"
	elog "http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c"
	elog
	elog "Example command to get the information for the new interface name before booting"
	elog "(replace <ifname> with, for example, eth0):"
	elog "# udevadm test-builtin net_id /sys/class/net/<ifname> 2> /dev/null"
	elog
	elog "You can use either kernel parameter \"net.ifnames=0\", create empty"
	elog "file /etc/systemd/network/99-default.link, or symlink it to /dev/null"
	elog "to disable the feature."

	if has_version 'sys-apps/biosdevname'; then
		ewarn
		ewarn "You can replace the functionality of sys-apps/biosdevname which has been"
		ewarn "detected to be installed with the new predictable network interface names."
	fi

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into effect."
	ewarn "The method you use to do this depends on your init system."
	if has_version 'sys-apps/openrc'; then
		ewarn "For sys-apps/openrc users it is:"
		ewarn "# /etc/init.d/udev --nodeps restart"
	fi

	elog
	elog "For more information on udev on Gentoo, upgrading, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "http://wiki.gentoo.org/wiki/Udev"
	elog "http://wiki.gentoo.org/wiki/Udev/upgrade"

	# If user has disabled 80-net-name-slot.rules using a empty file or a symlink to /dev/null,
	# do the same for 80-net-setup-link.rules to keep the old behavior
	local net_move=no
	local net_name_slot_sym=no
	local net_rules_path="${ROOT%/}"/etc/udev/rules.d
	local net_name_slot="${net_rules_path}"/80-net-name-slot.rules
	local net_setup_link="${net_rules_path}"/80-net-setup-link.rules
	if [[ ! -e ${net_setup_link} ]]; then
		[[ -f ${net_name_slot} && $(sed -e "/^#/d" -e "/^\W*$/d" ${net_name_slot} | wc -l) == 0 ]] && net_move=yes
		if [[ -L ${net_name_slot} && $(readlink ${net_name_slot}) == /dev/null ]]; then
			net_move=yes
			net_name_slot_sym=yes
		fi
	fi
	if [[ ${net_move} == yes ]]; then
		ebegin "Copying ${net_name_slot} to ${net_setup_link}"

		if [[ ${net_name_slot_sym} == yes ]]; then
			ln -nfs /dev/null "${net_setup_link}"
		else
			cp "${net_name_slot}" "${net_setup_link}"
		fi
		eend $?
	fi

	# Update hwdb database in case the format is changed by udev version.
	if has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT%/}"
		# Only reload when we are not upgrading to avoid potential race w/ incompatible hwdb.bin and the running udevd
		if [[ -z ${REPLACING_VERSIONS} ]]; then
			# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
			if [[ ${ROOT} != "" ]] && [[ ${ROOT} != "/" ]]; then
				return 0
			fi
			udevadm control --reload
		fi
	fi
}
