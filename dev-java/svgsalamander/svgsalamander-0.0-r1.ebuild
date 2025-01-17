# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-nodeps ant-trax"

inherit java-pkg-2 java-ant-2

# Created from
# https://svgsalamander.dev.java.net/svn/svgsalamander/tags/release-${PV}
# with bundled jars removed.
SRC_URI="mirror://gentoo/${P}.tar.bz2"
DESCRIPTION="a SVG engine for Java"
HOMEPAGE="https://svgsalamander.dev.java.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.5
	dev-java/ant-core:0"

DEPEND=">=virtual/jdk-1.5
	dev-java/javacc:0"

java_prepare() {
	# Delete these so that we don't need junit
	# They run a dialog any way so not useful for us
	rm -vr test/* examples/CVS || die

	cd lib || die
	java-pkg_jar-from --build-only javacc
	java-pkg_jar-from ant-core
}

src_install() {
	java-pkg_dojar build/jar/*.jar
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc build/javadoc
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/com
}
