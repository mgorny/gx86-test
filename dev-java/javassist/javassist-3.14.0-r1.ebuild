# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

# TODO add notes about where the distfile comes from
DESCRIPTION="Javassist makes Java bytecode manipulation simple"
SRC_URI="mirror://sourceforge/project/jboss/Javassist/${PV}.GA/javassist-${PV}-GA.zip"
HOMEPAGE="http://www.csg.is.titech.ac.jp/~chiba/javassist/"

LICENSE="MPL-1.1"
SLOT="3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}/${P}-GA"

EANT_DOC_TARGET="javadocs"
JAVA_ANT_REWRITE_CLASSPATH=y
EANT_NEEDS_TOOLS="yes"

java_prepare() {
	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dohtml Readme.html || die
	use doc && java-pkg_dojavadoc html
	use source && java-pkg_dosrc src/main/javassist
	use examples && java-pkg_doexamples sample/*
}
