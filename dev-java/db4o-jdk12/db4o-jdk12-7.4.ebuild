# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Core files for the object database for java"
HOMEPAGE="http://www.db4o.com"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEPEND="dev-java/db4o-jdk11"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}"

EANT_GENTOO_CLASSPATH="db4o-jdk11"

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc core/src/com
}
