# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="looks"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="2.6"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/jgoodies-common:1.8"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPEND}"

S="${WORKDIR}"/${P}

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="jgoodies-common-1.8"

java_prepare() {
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/pom.xml "${S}"/*.jar || die
}
