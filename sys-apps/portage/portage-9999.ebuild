# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=(
	pypy
	python3_2 python3_3 python3_4
	python2_7
)
# Note: substituted below
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1 git-r3 multilib

DESCRIPTION="Portage is the package management and distribution system for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="build doc epydoc +ipc linguas_ru selinux xattr"

DEPEND="!build? ( ${PYTHON_DEPS//bzip2(+)/ssl(+),bzip2(+)} )
	dev-lang/python-exec:2
	>=sys-apps/sed-4.0.5 sys-devel/patch
	doc? ( app-text/xmlto ~app-text/docbook-xml-dtd-4.4 )
	epydoc? ( >=dev-python/epydoc-2.0[$(python_gen_usedep 'python2*')] )"
# Require sandbox-2.2 for bug #288863.
# For xattr, we can spawn getfattr and setfattr from sys-apps/attr, but that's
# quite slow, so it's not considered in the dependencies as an alternative to
# to python-3.3 / pyxattr. Also, xattr support is only tested with Linux, so
# for now, don't pull in xattr deps for other kernels.
# For whirlpool hash, require python[ssl] or python-mhash (bug #425046).
# For compgen, require bash[readline] (bug #445576).
RDEPEND="
	dev-lang/python-exec:2
	!build? (
		>=sys-apps/sed-4.0.5
		|| ( >=app-shells/bash-4.2_p37[readline] ( <app-shells/bash-4.2_p37 >=app-shells/bash-3.2_p17 ) )
		>=app-admin/eselect-1.2
	)
	elibc_FreeBSD? ( sys-freebsd/freebsd-bin )
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_uclibc? ( >=sys-apps/sandbox-2.2 )
	>=app-misc/pax-utils-0.1.17
	selinux? ( >=sys-libs/libselinux-2.0.94[python,${PYTHON_USEDEP}] )
	xattr? ( kernel_linux? (
		>=sys-apps/install-xattr-0.3
		$(python_gen_cond_dep 'dev-python/pyxattr[${PYTHON_USEDEP}]' \
			python{2_7,3_2} pypy)
	) )
	!<app-shells/bash-3.2_p17
	!<app-admin/logrotate-3.8.0"
PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
		userland_GNU? ( >=sys-apps/coreutils-6.4 )
	)"
# coreutils-6.4 rdep is for date format in emerge-webrsync #164532
# NOTE: FEATURES=installsources requires debugedit and rsync

REQUIRED_USE="epydoc? ( $(python_gen_useflags 'python2*') )"

SRC_ARCHIVES="http://dev.gentoo.org/~dolsen/releases/portage"

prefix_src_archives() {
	local x y
	for x in ${@}; do
		for y in ${SRC_ARCHIVES}; do
			echo ${y}/${x}
		done
	done
}

EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/portage.git
	https://github.com/gentoo/portage.git"

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i pym/_emerge/AbstractEbuildProcess.py || \
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		sed -e "s|^\(SANDBOX_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/sandbox\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(FAKEROOT_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/fakeroot\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(BASH_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/bash\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(MOVE_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/mv\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(PRELINK_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/sbin/prelink\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(EPREFIX[[:space:]]*=[[:space:]]*\"\).*|\\1${EPREFIX}\"|" \
			-i pym/portage/const.py || \
			die "Failed to patch portage.const.EPREFIX"

		einfo "Prefixing shebangs ..."
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				sed -i -e "1s:.*:#!${EPREFIX}${shebang:2}:" "$REPLY" || \
					die "sed failed"
			fi
		done < <(find . -type f -print0)

		einfo "Adjusting make.globals ..."
		sed -e "s|\(/usr/portage\)|${EPREFIX}\\1|" \
			-e "s|^\(PORTAGE_TMPDIR=\"\)\(/var/tmp\"\)|\\1${EPREFIX}\\2|" \
			-i cnf/make.globals || die "sed failed"

		einfo "Adjusting repos.conf ..."
		sed -e "s|^\(main-repo = \).*|\\1gentoo_prefix|" \
			-e "s|^\\[gentoo\\]|[gentoo_prefix]|" \
			-e "s|^\(location = \)\(/usr/portage\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(sync-uri = \).*|\\1rsync://prefix.gentooexperimental.org/gentoo-portage-prefix|" \
			-i cnf/repos.conf || die "sed failed"

		einfo "Adding FEATURES=force-prefix to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} force-prefix"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	cd "${S}/cnf" || die
	if [ -f "make.conf.example.${ARCH}".diff ]; then
		patch make.conf.example "make.conf.example.${ARCH}".diff || \
			die "Failed to patch make.conf.example"
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
	fi
}

python_compile_all() {
	local targets=()
	use doc && targets+=( docbook )
	use epydoc && targets+=( epydoc )

	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi
}

python_test() {
	esetup.py test
}

python_install() {
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--portage-bindir="${EPREFIX}/usr/lib/portage/${EPYTHON}" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

python_install_all() {
	distutils-r1_python_install_all

	local targets=()
	use doc && targets+=( install_docbook )
	use epydoc && targets+=( install_epydoc )

	# install docs
	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi
}

pkg_preinst() {
	if [[ $ROOT == / ]] ; then
		# Run some minimal tests as a sanity check.
		local test_runner=$(find "${ED}" -name runTests)
		if [[ -n $test_runner && -x $test_runner ]] ; then
			einfo "Running preinst sanity tests..."
			"$test_runner" || die "preinst sanity tests failed"
		fi
	fi

	# elog dir must exist to avoid logrotate error for bug #415911.
	# This code runs in preinst in order to bypass the mapping of
	# portage:portage to root:root which happens after src_install.
	keepdir /var/log/portage/elog
	# This is allowed to fail if the user/group are invalid for prefix users.
	if chown portage:portage "${ED}"var/log/portage{,/elog} 2>/dev/null ; then
		chmod g+s,ug+rwx "${ED}"var/log/portage{,/elog}
	fi
}
