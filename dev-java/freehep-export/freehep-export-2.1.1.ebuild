# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE=""
GROUP_ID="org.freehep"
MAVEN2_REPOSITORIES="http://java.freehep.org/maven2"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="High Energy Physics Java library - FreeHEP Export and Save As Library"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=dev-java/freehep-swing-2.0.3
	dev-java/freehep-misc-deps
	dev-java/freehep-util"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
JAVA_GENTOO_CLASSPATH="freehep-swing,freehep-misc-deps,freehep-util"
