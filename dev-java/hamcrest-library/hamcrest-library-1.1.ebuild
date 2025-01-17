# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

MY_PN=${PN/-library}
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="http://code.google.com/p/${MY_PN}/"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/hamcrest-core:${SLOT}
	dev-java/hamcrest-generator:${SLOT}
	dev-java/qdox:1.6
"
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( sys-apps/findutils )
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} java java-to-jar"
EANT_GENTOO_CLASSPATH="hamcrest-generator,hamcrest-core,qdox-1.6"
EANT_BUILD_TARGET="library"
EANT_EXTRA_ARGS="-Dversion=${PV}"
EANT_GENTOO_CLASSPATH_EXTRA="build/${P}.jar"

java_prepare() {
	# remove core+generator target as they are already built.
	epatch "${FILESDIR}/${PV}-remove-targets.patch"

	find -iname "*.jar" -exec rm -v {} + || die "Unable to clean bundled JAR files"
}

src_install() {
	java-pkg_newjar build/${PN/core/library}-${PV}.jar ${PN/core/library}.jar

	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
