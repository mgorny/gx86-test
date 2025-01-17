# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit versionator

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://bash-completion.alioth.debian.org/"
SRC_URI="http://bash-completion.alioth.debian.org/files/${P}.tar.bz2
	http://dev.gentoo.org/~mgorny/dist/bashcomp2-pre1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND="|| ( >=app-shells/bash-4.1 app-shells/zsh )
	sys-apps/miscfiles
	!app-admin/eselect-bashcomp"

src_prepare() {
	epatch "${WORKDIR}"/bashcomp2-pre1/*.patch
}

src_test() { :; } # Skip testsuite because of interactive shell wrt #477066

src_install() {
	default

	# use the copies from >=sys-apps/util-linux-2.23 wrt #468544 -> hd and ncal
	# becomes dead symlinks as a result
	local file
	for file in cal dmesg eject hd hexdump hwclock ionice look ncal renice rtcwake; do
		rm "${ED}"/usr/share/bash-completion/completions/${file} || die
	done

	# use the copy from app-editors/vim-core:
	rm "${ED}"/usr/share/bash-completion/completions/xxd || die

	# use the copy from net-misc/networkmanager:
	rm "${ED}"/usr/share/bash-completion/completions/nmcli || die

	dodoc AUTHORS CHANGES README

	# install the eselect module
	insinto /usr/share/eselect/modules
	doins "${WORKDIR}"/bashcomp2-pre1/bashcomp.eselect
	doman "${WORKDIR}"/bashcomp2-pre1/bashcomp.eselect.5
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 2.1-r90 ${v}; then
			ewarn "For bash-completion autoloader to work, all completions need to"
			ewarn "be installed in /usr/share/bash-completion/completions. You may"
			ewarn "need to rebuild packages that installed completions in the old"
			ewarn "location. You can do this using:"
			ewarn
			ewarn "$ find ${EPREFIX}/usr/share/bash-completion -maxdepth 1 -type f '!' -name 'bash_completion' -exec emerge -1v {} +"
		fi
	done

	if has_version 'app-shells/zsh'; then
		elog
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
