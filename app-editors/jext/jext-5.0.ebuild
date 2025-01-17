# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A cool and fully featured editor in Java"
HOMEPAGE="http://www.jext.org/"
MY_PV="${PV/_}"
SRC_URI="mirror://sourceforge/${PN}/${PN}-sources-${MY_PV}.tar.gz"
LICENSE="|| ( GPL-2 JPython )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="
	dev-java/jython:0
	dev-java/jgoodies-looks:1.2
	dev-java/gnu-regexp:1"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-src-${MY_PV}"

java_prepare() {
	rm -v "${S}"/extplugins/Admin/*.jar || die
	# bundles some com.microstar.xml who knows what's that
	# also com.jgoodies.uif_lite which is apparently some jgoodies-looks
	# example code which we don't package and there is probably no point
	rm -rf src/lib/gnu || die
}

src_compile() {
	cd "${S}/src"
	eant jar $(use_doc javadocs) \
		-Dclasspath="$(java-pkg_getjars jython,jgoodies-looks-1.2,gnu-regexp-1)"
}

src_install () {
	java-pkg_newjar lib/${P}.jar
	java-pkg_dojar lib/dawn*.jar

	java-pkg_dolauncher ${PN} \
		--main org.jext.Jext \
		--java_args '-Dpython.path=$(java-config --classpath=jython)' \
		-pre "${FILESDIR}/${PN}-pre"

	use doc && java-pkg_dohtml -A .css .gif .jpg -r docs/api
}

pkg_postinst() {
	elog "Plugins are currently not built/installed. Patches welcome."
}
