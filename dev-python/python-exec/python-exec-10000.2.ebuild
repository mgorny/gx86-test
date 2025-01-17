# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# Kids, don't do this at home!
inherit python-utils-r1
PYTHON_COMPAT=( "${_PYTHON_ALL_IMPLS[@]}" )

inherit python-r1

DESCRIPTION="Compatibility package for dev-lang/python-exec"
HOMEPAGE="https://bitbucket.org/mgorny/python-exec/"
SRC_URI=""

LICENSE="BSD"
SLOT="2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/python-exec:0[${PYTHON_USEDEP}]
	dev-lang/python-exec:2[${PYTHON_USEDEP}]"
