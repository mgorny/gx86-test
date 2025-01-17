# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Mapping component of jackson for data binding"
HOMEPAGE="http://jackson.codehaus.org"
SRC_URI="http://repo1.maven.org/maven2/org/codehaus/${PN/-mapper/}/${PN}-lgpl/${PV}/${PN}-lgpl-${PV}-sources.jar"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/jackson:0
	dev-java/joda-time:0"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="jackson,joda-time"
