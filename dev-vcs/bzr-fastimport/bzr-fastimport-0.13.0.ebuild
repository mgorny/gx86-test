# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Plugin providing fast loading of revision control data into Bazaar"
HOMEPAGE="https://launchpad.net/bzr-fastimport http://wiki.bazaar.canonical.com/BzrFastImport"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-vcs/bzr-1.18
	>=dev-python/python-fastimport-0.9"
DEPEND=""

PYTHON_MODNAME="bzrlib/plugins/fastimport"
DOCS=( NEWS README.txt doc/notes.txt )

pkg_postinst() {
	distutils_pkg_postinst
	elog "These commands need additional dependencies:"
	elog
	elog "bzr fast-export-from-darcs:  dev-vcs/darcs"
	elog "bzr fast-export-from-git:    dev-vcs/git"
	elog "bzr fast-export-from-hg:     dev-vcs/mercurial"
	elog "bzr fast-export-from-mtn:    dev-vcs/monotone"
	elog "bzr fast-export-from-svn:    dev-vcs/subversion[python]"
}
