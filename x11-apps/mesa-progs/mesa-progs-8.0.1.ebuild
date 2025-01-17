# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

MY_PN=${PN/progs/demos}
MY_P=${MY_PN}-${PV}
EGIT_REPO_URI="git://anongit.freedesktop.org/${MY_PN/-//}"

if [[ ${PV} = 9999* ]]; then
	    GIT_ECLASS="git"
fi

inherit toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="Mesa's OpenGL utility and demo programs (glxgears and glxinfo)"
HOMEPAGE="http://mesa3d.sourceforge.net/"
if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/${MY_PN/-//}/${PV}/${MY_P}.tar.bz2"
fi

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# We're not using the complete buildsystem to avoid dependencies
	# unnecessary for our two little tools.
	:
}

src_compile() {
	tc-export CC
	emake LDLIBS='-lX11 -lGL -lm' src/xdemos/{glxgears,glxinfo} || die
}

src_install() {
	dobin src/xdemos/{glxgears,glxinfo} || die
}
