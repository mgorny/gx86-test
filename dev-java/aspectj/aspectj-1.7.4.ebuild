# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A seamless aspect-oriented extension to the Java programming language"
HOMEPAGE="http://eclipse.org/aspectj/"
SRC_URI="http://www.eclipse.org/downloads/download.php?file=/tools/${PN}/${P}-src.jar&r=1 -> ${P}-src.jar"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/asm:4
	dev-java/commons-logging:0"
DEPEND="${CDEPEND}
	app-arch/zip
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S=${WORKDIR}

JAVA_SRC_DIR="${S}/src"
JAVA_GENTOO_CLASSPATH="commons-logging,asm-4"

src_unpack() {
	default
	unzip "${S}"/aspectjweaver${PV}-src.jar -d "${S}"/src/ || die
}

java_prepare() {
	default

	# needs part of BEA JRockit to compile
	rm "${S}"/src/org/aspectj/weaver/loadtime/JRockitAgent.java || die
	# aspectj uses a renamed version of asm:4
	find -name "*.java" -exec sed -i -e 's/import aj.org.objectweb.asm./import org.objectweb.asm./g' {} \; || die
	mkdir -p "${S}"/target/classes/org/aspectj/weaver/ || die
	cp -vr "${S}"/src/org/aspectj/weaver/*.properties "${S}"/target/classes/org/aspectj/weaver/ || die
}
