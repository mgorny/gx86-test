# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# @ECLASS: java-vm-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @BLURB: Java Virtual Machine eclass
# @DESCRIPTION:
# This eclass provides functionality which assists with installing
# virtual machines, and ensures that they are recognized by java-config.

inherit eutils fdo-mime multilib pax-utils prefix

EXPORT_FUNCTIONS pkg_setup pkg_postinst pkg_prerm pkg_postrm

RDEPEND="
	=dev-java/java-config-2*
	|| ( app-admin/eselect-java <dev-java/java-config-2.2 )"
DEPEND="${RDEPEND}"
has "${EAPI}" 0 1 && DEPEND="${DEPEND} >=sys-apps/portage-2.1"

export WANT_JAVA_CONFIG=2


# @ECLASS-VARIABLE: JAVA_VM_CONFIG_DIR
# @INTERNAL
# @DESCRIPTION:
# Where to place the vm env file.
JAVA_VM_CONFIG_DIR="/usr/share/java-config-2/vm"

# @ECLASS-VARIABLE: JAVA_VM_DIR
# @INTERNAL
# @DESCRIPTION:
# Base directory for vm links.
JAVA_VM_DIR="/usr/lib/jvm"

# @ECLASS-VARIABLE: JAVA_VM_SYSTEM
# @INTERNAL
# @DESCRIPTION:
# Link for system-vm
JAVA_VM_SYSTEM="/etc/java-config-2/current-system-vm"

# @ECLASS-VARIABLE: JAVA_VM_BUILD_ONLY
# @DESCRIPTION:
# Set to YES to mark a vm as build-only.
JAVA_VM_BUILD_ONLY="${JAVA_VM_BUILD_ONLY:-FALSE}"


# @FUNCTION: java-vm-2_pkg_setup
# @DESCRIPTION:
# default pkg_setup
# 
# Initialize vm handle.

java-vm-2_pkg_setup() {
	if [[ "${SLOT}" != "0" ]]; then
		VMHANDLE=${PN}-${SLOT}
	else
		VMHANDLE=${PN}
	fi
}


# @FUNCTION: java-vm-2_pkg_postinst
# @DESCRIPTION:
# default pkg_postinst
#
# Set the generation-2 system VM and Java plugin, if it isn't set or the
# setting is invalid. Also update mime database.

java-vm-2_pkg_postinst() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT=${ROOT}
	# Note that we cannot rely on java-config here, as it will silently recognize
	# e.g. icedtea6-bin as valid system VM if icedtea6 is set but invalid (e.g. due
	# to the migration to icedtea-6)
	if [[ ! -L "${EROOT}${JAVA_VM_SYSTEM}" ]]; then
		java_set_default_vm_
	else
		local current_vm_path=$(readlink "${EROOT}${JAVA_VM_SYSTEM}")
		local current_vm=$(basename "${ROOT}${current_vm_path}")
		if [[ ! -L "${EROOT}${JAVA_VM_DIR}/${current_vm}" ]]; then
			java_set_default_vm_
		fi
	fi

	java-vm_check-nsplugin
	java_mozilla_clean_
	fdo-mime_desktop_database_update
}


# @FUNCTION: java-vm_check-nsplugin
# @INTERNAL
# @DESCRIPTION:
# Check if the nsplugin needs updating

java-vm_check-nsplugin() {
	local libdir
	if [[ ${VMHANDLE} =~ emul-linux-x86 ]]; then
		libdir=lib32
	else
		libdir=lib
	fi

	has ${EAPI:-0} 0 1 2 && ! use prefix && EPREFIX=

	# Install a default nsplugin if we don't already have one
	if in_iuse nsplugin && use nsplugin; then
		if [[ ! -f "${ROOT}${EPREFIX}"/usr/${libdir}/nsbrowser/plugins/javaplugin.so ]]; then
			einfo "No system nsplugin currently set."
			java-vm_set-nsplugin
		else
			einfo "System nsplugin is already set, not changing it."
		fi
		einfo "You can change nsplugin with eselect java-nsplugin."
	fi
}


# @FUNCTION: java-vm_set-nsplugin
# @INTERNAL
# @DESCRIPTION:
# Set the nsplugin implemetation.

java-vm_set-nsplugin() {
	local extra_args
	if use amd64; then
		if [[ ${VMHANDLE} =~ emul-linux-x86 ]]; then
			extra_args="32bit"
		else
			extra_args="64bit"
		fi
		einfo "Setting ${extra_args} nsplugin to ${VMHANDLE}"
	else
		einfo "Setting nsplugin to ${VMHANDLE}..."
	fi
	eselect java-nsplugin set ${extra_args} ${VMHANDLE}
}


# @FUNCTION: java-vm-2_pkg_prerm
# @DESCRIPTION:
# default pkg_prerm
#
# Warn user if removing system-vm.

java-vm-2_pkg_prerm() {
	# Although REPLACED_BY_VERSION is EAPI=4, we shouldn't need to check EAPI for this use case
	if [[ "$(GENTOO_VM="" java-config -f 2>/dev/null)" == "${VMHANDLE}" && -z "${REPLACED_BY_VERSION}" ]]; then
		ewarn "It appears you are removing your system-vm!"
		ewarn "Please run java-config -L to list available VMs,"
		ewarn "then use java-config -S to set a new system-vm!"
	fi
}


# @FUNCTION: java-vm-2_pkg_postrm
# @DESCRIPTION:
# default pkg_postrm
#
# Update mime database.

java-vm-2_pkg_postrm() {
	fdo-mime_desktop_database_update
}


# @FUNCTION: java_set_default_vm_
# @INTERNAL
# @DESCRIPTION:
# Set system-vm.

java_set_default_vm_() {
	java-config-2 --set-system-vm="${VMHANDLE}"

	einfo " ${P} set as the default system-vm."
}


# @FUNCTION: get_system_arch
# @DESCRIPTION:
# Get Java specific arch name.

get_system_arch() {
	local sarch
	sarch=$(echo ${ARCH} | sed -e s/[i]*.86/i386/ -e s/x86_64/amd64/ -e s/sun4u/sparc/ -e s/sparc64/sparc/ -e s/arm.*/arm/ -e s/sa110/arm/)
	if [ -z "${sarch}" ]; then
		sarch=$(uname -m | sed -e s/[i]*.86/i386/ -e s/x86_64/amd64/ -e s/sun4u/sparc/ -e s/sparc64/sparc/ -e s/arm.*/arm/ -e s/sa110/arm/)
	fi
	echo ${sarch}
}


# @FUNCTION: set_java_env
# @DESCRIPTION:
# Installs a vm env file.

# TODO rename to something more evident, like install_env_file
set_java_env() {
	debug-print-function ${FUNCNAME} $*

	if has ${EAPI:-0} 0 1 2 && ! use prefix ; then
		ED="${D}"
		EPREFIX=""
	fi

	local platform="$(get_system_arch)"
	local env_file="${ED}${JAVA_VM_CONFIG_DIR}/${VMHANDLE}"
	local old_env_file="${ED}/etc/env.d/java/20${P}"
	if [[ ${1} ]]; then
		local source_env_file="${1}"
	else
		local source_env_file="${FILESDIR}/${VMHANDLE}.env"
	fi

	if [[ ! -f ${source_env_file} ]]; then
		die "Unable to find the env file: ${source_env_file}"
	fi

	dodir ${JAVA_VM_CONFIG_DIR}
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PN@/${PN}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		-e "s/@SLOT@/${SLOT}/g" \
		-e "s/@PLATFORM@/${platform}/g" \
		-e "s/@LIBDIR@/$(get_libdir)/g" \
		-e "/^LDPATH=.*lib\\/\\\"/s|\"\\(.*\\)\"|\"\\1${platform}/:\\1${platform}/server/\"|" \
		< "${source_env_file}" \
		> "${env_file}" || die "sed failed"

	(
		echo "VMHANDLE=\"${VMHANDLE}\""
		echo "BUILD_ONLY=\"${JAVA_VM_BUILD_ONLY}\""
	) >> "${env_file}"

	eprefixify ${env_file}

	[[ -n ${JAVA_PROVIDE} ]] && echo "PROVIDES=\"${JAVA_PROVIDE}\"" >> ${env_file}

	local java_home=$(source "${env_file}"; echo ${JAVA_HOME})
	[[ -z ${java_home} ]] && die "No JAVA_HOME defined in ${env_file}"

	# Make the symlink
	dodir "${JAVA_VM_DIR}"
	dosym ${java_home#${EPREFIX}} ${JAVA_VM_DIR}/${VMHANDLE} \
		|| die "Failed to make VM symlink at ${JAVA_VM_DIR}/${VMHANDLE}"
}


# @FUNCTION: java-vm_set-pax-markings
# @DESCRIPTION:
# Set PaX markings on all JDK/JRE executables to allow code-generation on
# the heap by the JIT compiler.
# 
# The markings need to be set prior to the first invocation of the the freshly
# built / installed VM. Be it before creating the Class Data Sharing archive or
# generating cacerts. Otherwise a PaX enabled kernel will kill the VM.
# Bug #215225 #389751
#
# @CODE
#   Parameters:
#     $1 - JDK/JRE base directory.
#
#   Examples:
#     java-vm_set-pax-markings "${S}"
#     java-vm_set-pax-markings "${ED}"/opt/${P}
# @CODE

java-vm_set-pax-markings() {
	debug-print-function ${FUNCNAME} "$*"
	[[ $# -ne 1 ]] && die "${FUNCNAME}: takes exactly one argument"
	[[ ! -f "${1}"/bin/java ]] \
		&& die "${FUNCNAME}: argument needs to be JDK/JRE base directory"

	local executables=( "${1}"/bin/* )
	[[ -d "${1}"/jre ]] && executables+=( "${1}"/jre/bin/* )

	# Ensure a PaX header is created.
	local pax_markings="C"
	# Usally disabeling MPROTECT is sufficent.
	local pax_markings+="m"
	# On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
	use x86 && pax_markings+="sp"

	pax-mark ${pax_markings} $(list-paxables "${executables[@]}")
}


# @FUNCTION: java-vm_revdep-mask
# @DESCRIPTION:
# Installs a revdep-rebuild control file which SEARCH_DIR_MASK set to the path
# where the VM is installed. Prevents pointless rebuilds - see bug #177925.
# Also gives a notice to the user.
#
# @CODE
#   Parameters:
#     $1 - Path of the VM (defaults to /opt/${P} if not set)
#
#   Examples:
#     java-vm_revdep-mask
#     java-vm_revdep-mask /path/to/jdk/
#
# @CODE

java-vm_revdep-mask() {
	if has ${EAPI:-0} 0 1 2 && ! use prefix; then
		ED="${D}"
		EPREFIX=
	fi

	local VMROOT="${1-"${EPREFIX}"/opt/${P}}"

	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${VMROOT}\""> "${ED}/etc/revdep-rebuild/61-${VMHANDLE}"
}


# @FUNCTION: java-vm_sandbox-predict
# @DESCRIPTION:
# Install a sandbox control file. Specified paths won't cause a sandbox
# violation if opened read write but no write takes place. See bug 388937#c1
#
# @CODE
#   Examples:
#     java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
# @CODE

java-vm_sandbox-predict() {
	debug-print-function ${FUNCNAME} "$*"
	[[ -z "${1}" ]] && die "${FUNCNAME} takes at least one argument"

	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"

	local path path_arr=("$@")
	# subshell this to prevent IFS bleeding out dependant on bash version.
	# could use local, which *should* work, but that requires a lot of testing.
	path=$(IFS=":"; echo "${path_arr[*]}")
	dodir /etc/sandbox.d
	echo "SANDBOX_PREDICT=\"${path}\"" > "${ED}/etc/sandbox.d/20${VMHANDLE}" \
		|| die "Failed to write sandbox control file"
}


# @FUNCTION: java_get_plugin_dir_
# @INTERNAL
# @DESCRIPTION:
# Get the java plugin dir.

java_get_plugin_dir_() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EPREFIX=
	echo "${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
}


# @FUNCTION: install_mozilla_plugin
# @DESCRIPTION:
# Register a netscape java-plugin.

install_mozilla_plugin() {
	local plugin="${1}"
	local variant="${2}"

	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	if [[ ! -f "${ED}/${plugin}" ]]; then
		die "Cannot find mozilla plugin at ${ED}/${plugin}"
	fi

	if [[ -n "${variant}" ]]; then
		variant="-${variant}"
	fi

	local plugin_dir="/usr/share/java-config-2/nsplugin"
	dodir "${plugin_dir}"
	dosym "${plugin}" "${plugin_dir}/${VMHANDLE}${variant}-javaplugin.so"
}


# @FUNCTION: java_mozilla_clean_
# @INTERNAL
# @DESCRIPTION:
# Because previously some ebuilds installed symlinks outside of pkg_install
# and are left behind, which forces you to manualy remove them to select the
# jdk/jre you want to use for java

java_mozilla_clean_() {
	local plugin_dir=$(java_get_plugin_dir_)
	for file in ${plugin_dir}/javaplugin_*; do
		rm -f ${file}
	done
	for file in ${plugin_dir}/libjavaplugin*; do
		rm -f ${file}
	done
}
