# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit java-pkg-2

DESCRIPTION="a simpler, faster alternative to git-filter-branch for removing bad data from git repos"
HOMEPAGE="http://rtyley.github.io/bfg-repo-cleaner/"
SRC_URI="http://repo1.maven.org/maven2/com/madgag/${PN}/${PV}/${P}.jar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"
}

src_compile() { :; }

src_install() {
	java-pkg_newjar ${P}.jar
	java-pkg_dolauncher ${PN}
}
