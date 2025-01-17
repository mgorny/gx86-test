# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# XXX: we need to review menu.lst vs grub.conf handling.  We've been converting
#      all systems to grub.conf (and symlinking menu.lst to grub.conf), but
#      we never updated any of the source code (it still all wants menu.lst),
#      and there is no indication that upstream is making the transition.

# If you need to roll a new grub-static distfile, here is how.
# - Robin H. Johnson <robbat2@gentoo.org> - 29 Nov 2010
# FEATURES='-noauto -noinfo -nodoc -noman -splitdebug nostrip' \
# USE='static -ncurses -netboot -custom-cflags' \
# PORTAGE_COMPRESS=true GRUB_STATIC_PACKAGE_BUILDING=1 ebuild \
# grub-${PVR}.ebuild clean package && \
# qtbz2 -s -j ${PKGDIR}/${CAT}/${PF}.tbz2 && \
# mv ${PF}.tar.bz2 ${DISTDIR}/grub-static-${PVR}.tar.bz2

inherit mount-boot eutils flag-o-matic toolchain-funcs autotools linux-info pax-utils

PATCHVER="1.14" # Should match the revision ideally
DESCRIPTION="GNU GRUB Legacy boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gnu-alpha/${PN}/${P}.tar.gz
	mirror://gentoo/splash.xpm.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="custom-cflags ncurses netboot static"

RDEPEND="ncurses? (
		>=sys-libs/ncurses-5.2-r5
		amd64? ( app-emulation/emul-linux-x86-baselibs )
	)"
DEPEND="${RDEPEND}"

pkg_setup() {
	case $(tc-arch) in
	amd64) CONFIG_CHECK='~IA32_EMULATION' check_extra_config ;;
	esac
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Grub will not handle a kernel larger than EXTENDED_MEMSIZE Mb as
	# discovered in bug 160801. We can change this, however, using larger values
	# for this variable means that Grub needs more memory to run and boot. For a
	# kernel of size N, Grub needs (N+1)*2.  Advanced users should set a custom
	# value in make.conf, it is possible to make kernels ~16Mb in size, but it
	# needs the kitchen sink built-in.
	local t="custom"
	if [[ -z ${GRUB_MAX_KERNEL_SIZE} ]] ; then
		case $(tc-arch) in
		amd64) GRUB_MAX_KERNEL_SIZE=9 ;;
		x86)   GRUB_MAX_KERNEL_SIZE=5 ;;
		esac
		t="default"
	fi
	einfo "Grub will support the ${t} maximum kernel size of ${GRUB_MAX_KERNEL_SIZE} Mb (GRUB_MAX_KERNEL_SIZE)"

	sed -i \
		-e "/^#define.*EXTENDED_MEMSIZE/s,3,${GRUB_MAX_KERNEL_SIZE},g" \
		"${S}"/grub/asmstub.c \
		|| die

	if [[ -n ${PATCHVER} ]] ; then
		EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
		eautoreconf
	fi
}

src_compile() {
	filter-flags -fPIE #168834

	use amd64 && multilib_toolchain_setup x86

	unset BLOCK_SIZE #73499

	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.

	# grub-0.95 added -fno-stack-protector detection, to disable ssp for stage2,
	# but the objcopy's (faulty) test fails if -fstack-protector is default.
	# create a cache telling configure that objcopy is ok, and add -C to econf
	# to make use of the cache.
	#
	# CFLAGS has to be undefined running econf, else -fno-stack-protector detection fails.
	# STAGE2_CFLAGS is not allowed to be used on emake command-line, it overwrites
	# -fno-stack-protector detected by configure, removed from netboot's emake.
	use custom-cflags || unset CFLAGS

	export grub_cv_prog_objcopy_absolute=yes #79734
	use static && append-ldflags -static

	# Per bug 216625, the emul packages do not provide .a libs for performing
	# suitable static linking
	if use amd64 && use static ; then
		if [ -z "${GRUB_STATIC_PACKAGE_BUILDING}" ]; then
			die "You must use the grub-static package if you want a static Grub on amd64!"
		else
			eerror "You have set GRUB_STATIC_PACKAGE_BUILDING. This"
			eerror "is specifically intended for building the tarballs for the"
			eerror "grub-static package via USE='static -ncurses'."
			eerror "All bets are now off."
			ebeep 10
		fi
	fi

	# build the net-bootable grub first, but only if "netboot" is set
	if use netboot ; then
		econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		--enable-diskless \
		--enable-{3c{5{03,07,09,29,95},90x},cs89x0,davicom,depca,eepro{,100}} \
		--enable-{epic100,exos205,ni5210,lance,ne2100,ni{50,65}10,natsemi} \
		--enable-{ne,ns8390,wd,otulip,rtl8139,sis900,sk-g16,smc9000,tiara} \
		--enable-{tulip,via-rhine,w89c840}

		emake w89c840_o_CFLAGS="-O" || die

		mv -f stage2/{nbgrub,pxegrub} "${S}"/
		mv -f stage2/stage2 stage2/stage2.netboot

		emake -j1 clean || die
	fi

	# Now build the regular grub
	# Note that FFS and UFS2 support are broken for now - stage1_5 files too big
	econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		$(use_with ncurses curses)

	# sanity check due to common failure
	use ncurses && ! grep -qs "HAVE_LIBCURSES.*1" config.h && die "USE=ncurses but curses not found"

	emake || die "making regular stuff"
}

src_test() {
	# non-default block size also give false pass/fails.
	unset BLOCK_SIZE
	emake -j1 check || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	if use netboot ; then
		exeinto /usr/lib/grub/${CHOST}
		doexe nbgrub pxegrub stage2/stage2.netboot || die
	fi

	# bug 330745
	pax-mark -m "${D}"/sbin/grub

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
	dodoc "${FILESDIR}"/grub.conf.gentoo
	prepalldocs

	[ -n "${GRUB_STATIC_PACKAGE_BUILDING}" ] && \
		mv \
		"${D}"/usr/share/doc/${PF} \
		"${D}"/usr/share/doc/grub-static-${PF/grub-}

	insinto /usr/share/grub
	doins "${DISTDIR}"/splash.xpm.gz
}

setup_boot_dir() {
	local boot_dir=$1
	local dir=${boot_dir}

	mkdir -p "${dir}"
	[[ ! -L ${dir}/boot ]] && ln -s . "${dir}/boot"
	dir="${dir}/grub"
	if [[ ! -e ${dir} ]] ; then
		mkdir "${dir}" || die
	fi

	# change menu.lst to grub.conf
	if [[ ! -e ${dir}/grub.conf ]] && [[ -e ${dir}/menu.lst ]] ; then
		mv -f "${dir}"/menu.lst "${dir}"/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi

	if [[ ! -e ${dir}/menu.lst ]]; then
		einfo "Linking from new grub.conf name to menu.lst"
		ln -snf grub.conf "${dir}"/menu.lst
	fi

	if [[ -e ${dir}/stage2 ]] ; then
		mv "${dir}"/stage2{,.old}
		ewarn "*** IMPORTANT NOTE: you must run grub and install"
		ewarn "the new version's stage1 to your MBR.  Until you do,"
		ewarn "stage1 and stage2 will still be the old version, but"
		ewarn "later stages will be the new version, which could"
		ewarn "cause problems such as an unbootable system."
		ewarn "This means you must use either grub-install or perform"
		ewarn "root/setup manually! For more help, see the handbook:"
		ewarn "http://www.gentoo.org/doc/en/handbook/handbook-${ARCH}.xml?part=1&chap=10#grub-install-auto"
		ebeep
	fi

	einfo "Copying files from /lib/grub and /usr/share/grub to ${dir}"
	for x in \
		"${ROOT}"/lib*/grub/*/* \
		"${ROOT}"/usr/share/grub/* ; do
		[[ -f ${x} ]] && cp -p "${x}" "${dir}"/
	done

	if [[ ! -e ${dir}/grub.conf ]] ; then
		s="${ROOT}/usr/share/doc/${PF}/grub.conf.gentoo"
		[[ -e "${s}" ]] && cat "${s}" >${dir}/grub.conf
		[[ -e "${s}.gz" ]] && zcat "${s}.gz" >${dir}/grub.conf
		[[ -e "${s}.bz2" ]] && bzcat "${s}.bz2" >${dir}/grub.conf
	fi

	# Per bug 218599, we support grub.conf.install for users that want to run a
	# specific set of Grub setup commands rather than the default ones.
	grub_config=${dir}/grub.conf.install
	[[ -e ${grub_config} ]] || grub_config=${dir}/grub.conf
	if [[ -e ${grub_config} ]] ; then
		egrep \
			-v '^[[:space:]]*(#|$|default|fallback|initrd|password|splashimage|timeout|title)' \
			"${grub_config}" | \
		/sbin/grub --batch \
			--device-map="${dir}"/device.map \
			> /dev/null
	fi

	# the grub default commands silently piss themselves if
	# the default file does not exist ahead of time
	if [[ ! -e ${dir}/default ]] ; then
		grub-set-default --root-directory="${boot_dir}" default
	fi
	einfo "Grub has been installed to ${boot_dir} successfully."
}

pkg_postinst() {
	mount-boot_mount_boot_partition

	if [[ -n ${DONT_MOUNT_BOOT} ]]; then
		elog "WARNING: you have DONT_MOUNT_BOOT in effect, so you must apply"
		elog "the following instructions for your /boot!"
		elog "Neglecting to do so may cause your system to fail to boot!"
		elog
	else
		setup_boot_dir "${ROOT}"/boot
		# Trailing output because if this is run from pkg_postinst, it gets mixed into
		# the other output.
		einfo ""
	fi
	elog "To interactively install grub files to another device such as a USB"
	elog "stick, just run the following and specify the directory as prompted:"
	elog "   emerge --config =${PF}"
	elog "Alternately, you can export GRUB_ALT_INSTALLDIR=/path/to/use to tell"
	elog "grub where to install in a non-interactive way."

	# needs to be after we call setup_boot_dir
	mount-boot_pkg_postinst
}

pkg_config() {
	local dir
	if [ ! -d "${GRUB_ALT_INSTALLDIR}" ]; then
		einfo "Enter the directory where you want to setup grub:"
		read dir
	else
		dir="${GRUB_ALT_INSTALLDIR}"
	fi
	setup_boot_dir "${dir}"
}
