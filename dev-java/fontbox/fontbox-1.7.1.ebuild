# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN=pdfbox

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="http://pdfbox.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/${MY_PN}-${PV}-src.zip"

LICENSE="BSD"
SLOT="1.7"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x64-macos"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

S="${WORKDIR}/${MY_PN}-${PV}/${PN}"

java_prepare() {
	cp -v "${FILESDIR}"/${P}_maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_TEST_GENTOO_CLASSPATH="junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
