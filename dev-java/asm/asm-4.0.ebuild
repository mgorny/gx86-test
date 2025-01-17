# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

MY_P="${PN}-${PV/rc/RC}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="http://asm.ow2.org"
SRC_URI="http://download.forge.objectweb.org/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="4"
IUSE=""
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x64-macos"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

# Needs dependencies we don't have yet.
RESTRICT="test"

S="${WORKDIR}/${MY_P}"
EANT_DOC_TARGET="jdoc"

# Fails if this objectweb.ant.tasks.path is not set.
# Java generics seem to break unless product.noshrink is set.
EANT_EXTRA_ARGS="-Dobjectweb.ant.tasks.path=foobar -Dproduct.noshrink=true"

src_install() {
	for x in output/dist/lib/*.jar ; do
		java-pkg_newjar "${x}" $(basename "${x%-*}.jar")
	done

	use doc && java-pkg_dojavadoc output/dist/doc/javadoc/user/
	use source && java-pkg_dosrc src/*
}
