# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="5"

inherit eutils

HOMEPAGE="http://www.gentoo.org/proj/en/hardened/selinux/"
DESCRIPTION="SELinux policy for core modules"

IUSE="+unconfined"
BASEPOL="2.20140311-r4"

RDEPEND=">=sec-policy/selinux-base-${PVR}"
PDEPEND="unconfined? ( sec-policy/selinux-unconfined )"
DEPEND=""
SRC_URI="http://oss.tresys.com/files/refpolicy/refpolicy-${PV}.tar.bz2
		http://dev.gentoo.org/~swift/patches/${PN}/patchbundle-${PN}-${BASEPOL}.tar.bz2"
KEYWORDS="~amd64 ~x86"

MODS="application authlogin bootloader clock consoletype cron dmesg fstools getty hostname hotplug init iptables libraries locallogin logging lvm miscfiles modutils mount mta netutils nscd portage raid rsync selinuxutil setrans ssh staff storage su sysadm sysnetwork udev userdomain usermanage unprivuser xdg"
LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/"
PATCHBUNDLE="${DISTDIR}/patchbundle-selinux-base-policy-${BASEPOL}.tar.bz2"

# Code entirely copied from selinux-eclass (cannot inherit due to dependency on
# itself), when reworked reinclude it. Only postinstall (where -b base.pp is
# added) needs to remain then.

pkg_pretend() {
	for i in ${POLICY_TYPES}; do
		if [[ "${i}" == "targeted" ]] && ! use unconfined; then
			die "If you use POLICY_TYPES=targeted, then USE=unconfined is mandatory."
		fi
	done
}

src_prepare() {
	local modfiles

	# Patch the sources with the base patchbundle
	if [[ -n ${BASEPOL} ]];
	then
		cd "${S}"
		EPATCH_MULTI_MSG="Applying SELinux policy updates ... " \
		EPATCH_SUFFIX="patch" \
		EPATCH_SOURCE="${WORKDIR}" \
		EPATCH_FORCE="yes" \
		epatch
	fi

	# Apply the additional patches refered to by the module ebuild.
	# But first some magic to differentiate between bash arrays and strings
	if [[ "$(declare -p POLICY_PATCH 2>/dev/null 2>&1)" == "declare -a"* ]];
	then
		cd "${S}/refpolicy/policy/modules"
		for POLPATCH in "${POLICY_PATCH[@]}";
		do
			epatch "${POLPATCH}"
		done
	else
		if [[ -n ${POLICY_PATCH} ]];
		then
			cd "${S}/refpolicy/policy/modules"
			for POLPATCH in ${POLICY_PATCH};
			do
				epatch "${POLPATCH}"
			done
		fi
	fi

	# Calling user patches
	epatch_user

	# Collect only those files needed for this particular module
	for i in ${MODS}; do
		modfiles="$(find ${S}/refpolicy/policy/modules -iname $i.te) $modfiles"
		modfiles="$(find ${S}/refpolicy/policy/modules -iname $i.fc) $modfiles"
	done

	for i in ${POLICY_TYPES}; do
		mkdir "${S}"/${i} || die "Failed to create directory ${S}/${i}"
		cp "${S}"/refpolicy/doc/Makefile.example "${S}"/${i}/Makefile \
			|| die "Failed to copy Makefile.example to ${S}/${i}/Makefile"

		cp ${modfiles} "${S}"/${i} \
			|| die "Failed to copy the module files to ${S}/${i}"
	done
}

src_compile() {
	for i in ${POLICY_TYPES}; do
		# Parallel builds are broken, so we need to force -j1 here
		emake -j1 NAME=$i -C "${S}"/${i} || die "${i} compile failed"
	done
}

src_install() {
	local BASEDIR="/usr/share/selinux"

	for i in ${POLICY_TYPES}; do
		for j in ${MODS}; do
			einfo "Installing ${i} ${j} policy package"
			insinto ${BASEDIR}/${i}
			doins "${S}"/${i}/${j}.pp || die "Failed to add ${j}.pp to ${i}"
		done
	done
}

pkg_postinst() {
	# Override the command from the eclass, we need to load in base as well here
	local COMMAND
	for i in ${MODS}; do
		COMMAND="-i ${i}.pp ${COMMAND}"
	done

	for i in ${POLICY_TYPES}; do
		einfo "Inserting the following modules, with base, into the $i module store: ${MODS}"

		cd /usr/share/selinux/${i} || die "Could not enter /usr/share/selinux/${i}"

		semodule -s ${i} -b base.pp ${COMMAND} || die "Failed to load in base and modules ${MODS} in the $i policy store"
	done
}
