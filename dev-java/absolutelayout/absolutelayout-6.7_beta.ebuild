# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit java-pkg-2 java-ant-2

DESCRIPTION="AbsoluteLayout files extracted from Netbeans"
HOMEPAGE="http://www.netbeans.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( GPL-2 CDDL )"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}"

src_compile() {
	mkdir build
	ejavac -d build $(find . -iname '*.java')
	jar cf "${PN}.jar" -C build org
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}
