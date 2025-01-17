# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_DATE="20031218"

DESCRIPTION="RELAX NG Compiler Compiler"
HOMEPAGE="http://relaxngcc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_DATE}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/relaxng-datatype:0
	dev-java/msv:0
	dev-java/ant-core:0
	dev-java/xsdlib:0"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_DATE}"

java_prepare() {
	mv relaxngcc.jar relaxngcc.orig.zip || die

	rm -v *.jar || die
	rm -v sample/*/*.class || die

	mkdir lib || die
	cd lib || die
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom msv
	java-pkg_jarfrom xsdlib
	java-pkg_jarfrom ant-core
	cd "${S}" || die

	cp "${FILESDIR}/build.xml-1.12-r1" build.xml || die "cp failed"
	rm -rf "src/relaxngcc/maven"
	java-pkg_filter-compiler jikes
}

EANT_DOC_TARGET=""

src_install() {

	java-pkg_dojar relaxngcc.jar

	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples sample

	dodoc readme.txt || die
	use doc && dohtml -r doc/en/*

}
