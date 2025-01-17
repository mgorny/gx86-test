# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# Upstream switched to Maven as a build system. Current build.xml file was generated by running mvn ant:ant
# A bit of tweaking was required unfortunately

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A Java library for working with the command line arguments and options"
HOMEPAGE="http://commons.apache.org/cli/"
MY_P="${P}-src"
SRC_URI="mirror://apache/commons/cli/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=""

RDEPEND=">=virtual/jre-1.4"
# Blocking junit for https://bugs.gentoo.org/show_bug.cgi?id=215659
DEPEND=">=virtual/jdk-1.4
	!<dev-java/junit-3.8.2
	test? ( dev-java/ant-junit )"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/build-${PV}.xml" "${S}/build.xml"
}

src_install() {
	java-pkg_newjar "target/${P}.jar"

	dodoc README.txt RELEASE-NOTES.txt || die
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/java/org
}

# org.apache.commons.cli.ParserTestCase should not be ran, so we removed this class in build.xml

src_test() {
	ANT_TASKS="ant-junit"
	eant -Djunit.present="true" test
}
