# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit toolchain-funcs git-r3

EGIT_REPO_URI="git://git.codemonkey.org.uk/trinity"

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

DEPEND="sys-kernel/linux-headers"

src_prepare() {
	sed -e 's/-g -O2//' \
		-e 's/-D_FORTIFY_SOURCE=2//' \
		-e '/-o $@/s/$(LDFLAGS) //' \
		-i Makefile || die

	tc-export CC
}

src_configure() {
	./configure.sh || die
}

src_compile() {
	emake V=1
}

src_install() {
	dobin ${PN}
	dodoc Documentation/* README

	if use examples ; then
		exeinto /usr/share/doc/${PF}/scripts
		doexe scripts/*
		docompress -x /usr/share/doc/${PF}/scripts
	fi
}
