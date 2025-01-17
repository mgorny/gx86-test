# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 pypy pypy2_0 )
PYTHON_REQ_USE="readline(+)"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/williamh/pybugz.git
		https://github.com/williamh/pybugz.git"
	inherit git-r3
else
	SRC_URI="https://github.com/williamh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
	inherit vcs-snapshot
fi

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Command line interface to (Gentoo) Bugzilla"
HOMEPAGE="http://www.github.com/williamh/pybugz"
LICENSE="GPL-2"
SLOT="0"
IUSE="zsh-completion"

RDEPEND="${DEPEND}
	zsh-completion? ( app-shells/zsh )"

PATCHES=( "${FILESDIR}"/${P}-bugzilla-4.4.1.patch )

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp contrib/bash-completion bugz

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh-completion _pybugz
	fi
}
