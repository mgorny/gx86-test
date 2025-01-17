# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

#BACKPORTS=062ad8b2
AUTOTOOLIZE=yes

MY_P="${P/_rc/-rc}"

inherit eutils user autotools linux-info systemd readme.gentoo

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://libvirt.org/libvirt.git"
	AUTOTOOLIZE=yes
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://libvirt.org/sources/${MY_P}.tar.gz
		ftp://libvirt.org/libvirt/${MY_P}.tar.gz
		${BACKPORTS:+
			http://dev.gentoo.org/~cardoe/distfiles/${MY_P}-${BACKPORTS}.tar.xz}"
	KEYWORDS="~amd64 ~x86"
fi
S="${WORKDIR}/${P%_rc*}"

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="http://www.libvirt.org/"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="audit avahi +caps firewalld fuse iscsi +libvirtd lvm lxc +macvtap nfs \
	nls numa openvz parted pcap phyp policykit +qemu rbd sasl \
	selinux +udev uml +vepa virtualbox virt-network xen elibc_glibc \
	systemd"
REQUIRED_USE="libvirtd? ( || ( lxc openvz qemu uml virtualbox xen ) )
	lxc? ( caps libvirtd )
	openvz? ( libvirtd )
	qemu? ( libvirtd )
	uml? ( libvirtd )
	vepa? ( macvtap )
	virtualbox? ( libvirtd )
	xen? ( libvirtd )
	virt-network? ( libvirtd )
	firewalld? ( virt-network )"

# gettext.sh command is used by the libvirt command wrappers, and it's
# non-optional, so put it into RDEPEND.
# We can use both libnl:1.1 and libnl:3, but if you have both installed, the
# package will use 3 by default. Since we don't have slot pinning in an API,
# we must go with the most recent
RDEPEND="sys-libs/readline
	sys-libs/ncurses
	>=net-misc/curl-7.18.0
	dev-libs/libgcrypt
	>=dev-libs/libxml2-2.7.6
	dev-libs/libnl:3
	>=net-libs/gnutls-1.0.25
	net-libs/libssh2
	sys-apps/dmidecode
	>=sys-apps/util-linux-2.17
	sys-devel/gettext
	>=net-analyzer/netcat6-1.0-r2
	app-misc/scrub
	audit? ( sys-process/audit )
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	caps? ( sys-libs/libcap-ng )
	fuse? ( >=sys-fs/fuse-2.8.6 )
	iscsi? ( sys-block/open-iscsi )
	lxc? ( !systemd? ( sys-power/pm-utils ) )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2 )
	nfs? ( net-fs/nfs-utils )
	numa? (
		>sys-process/numactl-2.0.2
		sys-process/numad
	)
	openvz? ( sys-kernel/openvz-sources )
	parted? (
		>=sys-block/parted-1.8[device-mapper]
		sys-fs/lvm2
	)
	pcap? ( >=net-libs/libpcap-1.0.0 )
	policykit? ( >=sys-auth/polkit-0.9 )
	qemu? (
		>=app-emulation/qemu-0.13.0
		dev-libs/yajl
		!systemd? ( sys-power/pm-utils )
	)
	rbd? ( sys-cluster/ceph )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( >=sys-libs/libselinux-2.0.85 )
	systemd? ( sys-apps/systemd )
	virtualbox? ( || ( app-emulation/virtualbox >=app-emulation/virtualbox-bin-2.2.0 ) )
	xen? ( app-emulation/xen-tools app-emulation/xen )
	udev? ( virtual/udev >=x11-libs/libpciaccess-0.10.9 )
	virt-network? ( net-dns/dnsmasq
		>=net-firewall/iptables-1.4.10
		net-misc/radvd
		net-firewall/ebtables
		sys-apps/iproute2[-minimal]
		firewalld? ( net-firewall/firewalld )
	)
	elibc_glibc? ( || ( >=net-libs/libtirpc-0.2.2-r1 <sys-libs/glibc-2.14 ) )"
# one? ( dev-libs/xmlrpc-c )
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/xhtml1
	dev-lang/perl
	dev-libs/libxslt"

DOC_CONTENTS="For the basic networking support (bridged and routed networks)
you don't need any extra software. For more complex network modes
including but not limited to NATed network, you can enable the
'virt-network' USE flag.\n\n
If you are using dnsmasq on your system, you will have
to configure /etc/dnsmasq.conf to enable the following settings:\n\n
 bind-interfaces\n
 interface or except-interface\n\n
Otherwise you might have issues with your existing DNS server."

LXC_CONFIG_CHECK="
	~CGROUPS
	~CGROUP_FREEZER
	~CGROUP_DEVICE
	~CGROUP_CPUACCT
	~CGROUP_SCHED
	~CGROUP_PERF
	~BLK_CGROUP
	~NET_CLS_CGROUP
	~CGROUP_NET_PRIO
	~CPUSETS
	~RESOURCE_COUNTERS
	~NAMESPACES
	~UTS_NS
	~IPC_NS
	~PID_NS
	~NET_NS
	~USER_NS
	~DEVPTS_MULTIPLE_INSTANCES
	~VETH
	~MACVLAN
	~POSIX_MQUEUE
	~SECURITYFS
	~!GRKERNSEC_CHROOT_MOUNT
	~!GRKERNSEC_CHROOT_DOUBLE
	~!GRKERNSEC_CHROOT_PIVOT
	~!GRKERNSEC_CHROOT_CHMOD
	~!GRKERNSEC_CHROOT_CAPS
"

VIRTNET_CONFIG_CHECK="
	~BRIDGE_NF_EBTABLES
	~BRIDGE_EBT_MARK_T
	~NETFILTER_ADVANCED
	~NETFILTER_XT_TARGET_CHECKSUM
	~NETFILTER_XT_CONNMARK
	~NETFILTER_XT_MARK
"

BWLMT_CONFIG_CHECK="
	~BRIDGE_EBT_T_NAT
	~NET_SCH_HTB
	~NET_SCH_SFQ
	~NET_SCH_INGRESS
	~NET_CLS_FW
	~NET_CLS_U32
	~NET_ACT_POLICE
"

MACVTAP_CONFIG_CHECK=" ~MACVTAP"

LVM_CONFIG_CHECK=" ~BLK_DEV_DM ~DM_SNAPSHOT ~DM_MULTIPATH"

ERROR_USER_NS="Optional depending on LXC configuration."

pkg_setup() {
	enewgroup qemu 77
	enewuser qemu 77 -1 -1 qemu kvm

	# Some people used the masked ebuild which was not adding the qemu
	# user to the kvm group originally. This results in VMs failing to
	# start for some users. bug #430808
	egetent group kvm | grep -q qemu
	if [[ $? -ne 0 ]]; then
		gpasswd -a qemu kvm
	fi

	# Handle specific kernel versions for different features
	kernel_is lt 3 6 && LXC_CONFIG_CHECK+=" ~CGROUP_MEM_RES_CTLR"
	kernel_is ge 3 6 &&	LXC_CONFIG_CHECK+=" ~MEMCG ~MEMCG_SWAP ~MEMCG_KMEM"

	CONFIG_CHECK=""
	use fuse && CONFIG_CHECK+=" ~FUSE_FS"
	use lvm && CONFIG_CHECK+="${LVM_CONFIG_CHECK}"
	use lxc && CONFIG_CHECK+="${LXC_CONFIG_CHECK}"
	use macvtap && CONFIG_CHECK+="${MACVTAP_CONFIG_CHECK}"
	use virt-network && CONFIG_CHECK+="${VIRTNET_CONFIG_CHECK}"
	# Bandwidth Limiting Support
	use virt-network && CONFIG_CHECK+="${BWLMT_CONFIG_CHECK}"
	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi
}

src_prepare() {
	touch "${S}/.mailmap"
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" \
			epatch

	if [[ ${PV} = *9999* ]]; then

		# git checkouts require bootstrapping to create the configure script.
		# Additionally the submodules must be cloned to the right locations
		# bug #377279
		./bootstrap || die "bootstrap failed"
		(
			git submodule status | sed 's/^[ +-]//;s/ .*//'
			git hash-object bootstrap.conf
		) >.git-module-status
	fi

	epatch_user

	[[ -n ${AUTOTOOLIZE} ]] && eautoreconf

	# Tweak the init script
	local avahi_init=
	local iscsi_init=
	local rbd_init=
	local firewalld_init=
	cp "${FILESDIR}/libvirtd.init-r13" "${S}/libvirtd.init"
	use avahi && avahi_init='avahi-daemon'
	use iscsi && iscsi_init='iscsid'
	use rbd && rbd_init='ceph'
	use firewalld && firewalld_init='need firewalld'

	sed -e "s/USE_FLAG_FIREWALLD/${firewalld_init}/" -i "${S}/libvirtd.init"
	sed -e "s/USE_FLAG_AVAHI/${avahi_init}/" -i "${S}/libvirtd.init"
	sed -e "s/USE_FLAG_ISCSI/${iscsi_init}/" -i "${S}/libvirtd.init"
	sed -e "s/USE_FLAG_RBD/${rbd_init}/" -i "${S}/libvirtd.init"

	epatch "${FILESDIR}/${P}-numa.patch"
}

src_configure() {
	local myconf=""

	## enable/disable daemon, otherwise client only utils
	myconf="${myconf} $(use_with libvirtd)"

	## enable/disable the daemon using avahi to find VMs
	myconf="${myconf} $(use_with avahi)"

	## hypervisors on the local host
	myconf="${myconf} $(use_with xen) $(use_with xen xen-inotify)"
	myconf+=" --without-xenapi"
	if use xen && has_version ">=app-emulation/xen-tools-4.2.0"; then
		myconf+=" --with-libxl"
	else
		myconf+=" --without-libxl"
	fi
	myconf="${myconf} $(use_with openvz)"
	myconf="${myconf} $(use_with lxc)"
	if use virtualbox && has_version app-emulation/virtualbox-ose; then
		myconf="${myconf} --with-vbox=/usr/lib/virtualbox-ose/"
	else
		myconf="${myconf} $(use_with virtualbox vbox)"
	fi
	myconf="${myconf} $(use_with uml)"
	myconf="${myconf} $(use_with qemu)"
	myconf="${myconf} $(use_with qemu yajl)" # Use QMP over HMP
	myconf="${myconf} $(use_with phyp)"
	myconf="${myconf} --with-esx"
	myconf="${myconf} --with-vmware"

	## additional host drivers
	myconf="${myconf} $(use_with virt-network network)"
	myconf="${myconf} --with-storage-fs"
	myconf="${myconf} $(use_with lvm storage-lvm)"
	myconf="${myconf} $(use_with iscsi storage-iscsi)"
	myconf="${myconf} $(use_with parted storage-disk)"
	myconf="${myconf} $(use_with lvm storage-mpath)"
	myconf="${myconf} $(use_with rbd storage-rbd)"
	myconf="${myconf} $(use_with numa numactl)"
	myconf="${myconf} $(use_with numa numad)"
	myconf="${myconf} $(use_with selinux)"
	myconf="${myconf} $(use_with fuse)"

	# udev for device support details
	myconf="${myconf} $(use_with udev)"

	# linux capability support so we don't need privileged accounts
	myconf="${myconf} $(use_with caps capng)"

	## auth stuff
	myconf="${myconf} $(use_with policykit polkit)"
	myconf="${myconf} $(use_with sasl)"

	# network bits
	myconf="${myconf} $(use_with macvtap)"
	myconf="${myconf} $(use_with pcap libpcap)"
	myconf="${myconf} $(use_with vepa virtualport)"
	myconf="${myconf} $(use_with firewalld)"

	## other
	myconf="${myconf} $(use_enable nls)"

	# user privilege bits fir qemu/kvm
	if use caps; then
		myconf="${myconf} --with-qemu-user=qemu"
		myconf="${myconf} --with-qemu-group=qemu"
	else
		myconf="${myconf} --with-qemu-user=root"
		myconf="${myconf} --with-qemu-group=root"
	fi

	# audit support
	myconf="${myconf} $(use_with audit)"

	## stuff we don't yet support
	myconf="${myconf} --without-netcf"
	myconf="${myconf} --without-wireshark-dissector"

	# we use udev over hal
	myconf="${myconf} --without-hal"

	# locking support
	myconf="${myconf} --without-sanlock"

	# systemd unit files
	use systemd && myconf="${myconf} --with-init-script=systemd"

	# this is a nasty trick to work around the problem in bug
	# #275073. The reason why we don't solve this properly is that
	# it'll require us to rebuild autotools (and we don't really want
	# to do that right now). The proper solution has been sent
	# upstream and should hopefully land in 0.7.7, in the mean time,
	# mime the same functionality with this.
	case ${CHOST} in
		*cygwin* | *mingw* )
			;;
		*)
			ac_cv_prog_WINDRES=no
			;;
	esac

	econf \
		${myconf} \
		--disable-static \
		--docdir=/usr/share/doc/${PF} \
		--with-remote \
		--localstatedir=/var

	if [[ ${PV} = *9999* ]]; then
		# Restore gnulib's config.sub and config.guess
		# bug #377279
		(cd .gnulib && git reset --hard > /dev/null)
	fi
}

src_test() {
	# Explicitly allow parallel build of tests
	export VIR_TEST_DEBUG=1
	HOME="${T}" emake check || die "tests failed"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		HTML_DIR=/usr/share/doc/${PF}/html \
		DOCS_DIR=/usr/share/doc/${PF} \
		EXAMPLE_DIR=/usr/share/doc/${PF}/examples \
		SYSTEMD_UNIT_DIR="$(systemd_get_unitdir)" \
		|| die "emake install failed"

	find "${D}" -name '*.la' -delete || die

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	newinitd "${S}/libvirtd.init" libvirtd || die
	newconfd "${FILESDIR}/libvirtd.confd-r4" libvirtd || die
	newinitd "${FILESDIR}/virtlockd.init" virtlockd || die

	keepdir /var/lib/libvirt/{boot,images,network}
	use qemu && keepdir /var/{cache,lib,log}/libvirt/qemu
	use lxc && keepdir /var/{cache,lib,log}/libvirt/lxc

	readme.gentoo_create_doc
}

pkg_preinst() {
	# we only ever want to generate this once
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		rm -rf "${D}"/etc/libvirt/qemu/networks/default.xml
	fi

	# We really don't want to use or support old PolicyKit cause it
	# screws with the new polkit integration
	if has_version sys-auth/policykit; then
		rm -rf "${D}"/usr/share/PolicyKit/policy/org.libvirt.unix.policy
	fi

	# Only sysctl files ending in .conf work
	dodir /etc/sysctl.d
	mv "${D}"/usr/lib/sysctl.d/libvirtd.conf "${D}"/etc/sysctl.d/libvirtd.conf
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		touch "${ROOT}"/etc/libvirt/qemu/networks/default.xml
	fi

	# support for dropped privileges
	if use qemu; then
		fperms 0750 "${EROOT}/var/lib/libvirt/qemu"
		fperms 0750 "${EROOT}/var/cache/libvirt/qemu"
	fi

	if use caps && use qemu; then
		fowners -R qemu:qemu "${EROOT}/var/lib/libvirt/qemu"
		fowners -R qemu:qemu "${EROOT}/var/cache/libvirt/qemu"
	elif use qemu; then
		fowners -R root:root "${EROOT}/var/lib/libvirt/qemu"
		fowners -R root:root "${EROOT}/var/cache/libvirt/qemu"
	fi

	if ! use policykit; then
		elog "To allow normal users to connect to libvirtd you must change the"
		elog "unix sock group and/or perms in /etc/libvirt/libvirtd.conf"
	fi

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	readme.gentoo_print_elog

	if use caps && use qemu; then
		elog "libvirt will now start qemu/kvm VMs with non-root privileges."
		elog "Ensure any resources your VMs use are accessible by qemu:qemu"
	fi
}
