# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
WANT_ANT_TASKS="ant-nodeps"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Mobility Cluster"
HOMEPAGE="http://netbeans.org/features/platform/"
SLOT="7.0"
SOURCE_URL="http://download.netbeans.org/netbeans/7.0.1/final/zip/netbeans-7.0.1-201107282000-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-${SLOT}-build.xml-r1.patch.bz2
	http://hg.netbeans.org/binaries/CEF99941E945D543DF0711F2C6AEF765B50F8501-jakarta-slide-ant-webdav-2.1.jar
	http://hg.netbeans.org/binaries/D1B5BA3BFE8DCFAF08A0468F8879EF1D0E998038-jakarta-slide-webdavlib-2.1.jar
	http://hg.netbeans.org/binaries/2FB485DD8C5EFC7972037781BFFF0CE31316FCE6-jmunit-1.2.1-api.zip
	http://hg.netbeans.org/binaries/BD84F1A4C0789070CC62A8D2DBA75121A57C069C-jmunit4cldc10-1.2.1.jar
	http://hg.netbeans.org/binaries/D76B8334DCBDBE93297AA5C02B17D9A856E72246-jmunit4cldc11-1.2.1.jar
	http://hg.netbeans.org/binaries/3A5C68B301F42D3E8D89976F90D4E2AE6F2984B6-nbactivesync-5.0.jar
	http://hg.netbeans.org/binaries/2EF44D925014E2EF76416535CC0F3A7C7E9F4AE1-perseus-nb-1.0.jar
	http://hg.netbeans.org/binaries/793B8D020D81284E0B67FB635C17026121F06433-RicohAntTasks-2.0.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-apisupport-${PV}
	~dev-java/netbeans-enterprise-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-websvccommon-${PV}
	dev-java/ant-contrib:0
	dev-java/commons-codec:0
	dev-java/commons-httpclient:3
	dev-java/jdom:1.0"
DEPEND="virtual/jdk:1.6
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0"
RDEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.mobility -Dext.binaries.downloaded=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f | grep -vE "mobility.databindingme/lib/netbeans_databindingme.*\.jar" \
		| grep -v "vmd.components.midp/netbeans_midp_components_basic/dist/netbeans_midp_components_basic.jar" \
		| grep -v "vmd.components.midp.pda/netbeans_midp_components_pda/dist/netbeans_midp_components_pda.jar" \
		| grep -v "vmd.components.midp.wma/netbeans_midp_components_wma/dist/netbeans_midp_components_wma.jar" \
		| grep -v "vmd.components.svg/nb_svg_midp_components/dist/nb_svg_midp_components.jar" | xargs rm

	unpack netbeans-7.0-build.xml-r1.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/CEF99941E945D543DF0711F2C6AEF765B50F8501-jakarta-slide-ant-webdav-2.1.jar mobility.deployment.webdav/external/jakarta-slide-ant-webdav-2.1.jar || die
	ln -s "${DISTDIR}"/D1B5BA3BFE8DCFAF08A0468F8879EF1D0E998038-jakarta-slide-webdavlib-2.1.jar mobility.deployment.webdav/external/jakarta-slide-webdavlib-2.1.jar || die
	ln -s "${DISTDIR}"/2FB485DD8C5EFC7972037781BFFF0CE31316FCE6-jmunit-1.2.1-api.zip mobility.j2meunit/external/jmunit-1.2.1-api.zip || die
	ln -s "${DISTDIR}"/BD84F1A4C0789070CC62A8D2DBA75121A57C069C-jmunit4cldc10-1.2.1.jar mobility.j2meunit/external/jmunit4cldc10-1.2.1.jar || die
	ln -s "${DISTDIR}"/D76B8334DCBDBE93297AA5C02B17D9A856E72246-jmunit4cldc11-1.2.1.jar mobility.j2meunit/external/jmunit4cldc11-1.2.1.jar || die
	ln -s "${DISTDIR}"/3A5C68B301F42D3E8D89976F90D4E2AE6F2984B6-nbactivesync-5.0.jar o.n.mobility.lib.activesync/external/nbactivesync-5.0.jar || die
	ln -s "${DISTDIR}"/2EF44D925014E2EF76416535CC0F3A7C7E9F4AE1-perseus-nb-1.0.jar svg.perseus/external/perseus-nb-1.0.jar || die
	ln -s "${DISTDIR}"/793B8D020D81284E0B67FB635C17026121F06433-RicohAntTasks-2.0.jar j2me.cdc.project.ricoh/external/RicohAntTasks-2.0.jar || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-7.0-build.xml-r1.patch
	sed -i "/release\.external.*nbactivesync\.dll/d" o.n.mobility.lib.activesync/nbproject/project.properties || die

	# Support for custom patches
	if [ -n "${NETBEANS70_PATCHES_DIR}" -a -d "${NETBEANS70_PATCHES_DIR}" ] ; then
		local files=`find "${NETBEANS70_PATCHES_DIR}" -type f`

		if [ -n "${files}" ] ; then
			einfo "Applying custom patches:"

			for file in ${files} ; do
				epatch "${file}"
			done
		fi
	fi

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --into j2me.cdc.project.ricoh/external commons-codec commons-codec.jar commons-codec-1.3.jar
	java-pkg_jar-from --into j2me.cdc.project.ricoh/external commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.jar
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into mobility.antext/external ant-contrib ant-contrib.jar ant-contrib-1.0b3.jar
	java-pkg_jar-from --into mobility.deployment.webdav/external commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.1.jar
	java-pkg_jar-from --into mobility.deployment.webdav/external jdom-1.0 jdom.jar jdom-1.0.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-apisupport-${SLOT} apisupport || die
	cat /usr/share/netbeans-apisupport-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.apisupport.built

	ln -s /usr/share/netbeans-enterprise-${SLOT} enterprise || die
	cat /usr/share/netbeans-enterprise-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.enterprise.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-java-${SLOT} java || die
	cat /usr/share/netbeans-java-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.java.built

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-websvccommon-${SLOT} websvccommon || die
	cat /usr/share/netbeans-websvccommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.websvccommon.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans/mobility >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/mobility$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	rm -rf "${D}"/${INSTALL_DIR}/modules/lib || die

	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext
	pushd "${D}"/${instdir} >/dev/null || die
	rm ant-contrib-1.0b3.jar && dosym /usr/share/ant-contrib/lib/ant-contrib.jar ${instdir}/ant-contrib-1.0b3.jar || die
	# cdc-agui-swing-layout.jar
	# cdc-pp-awt-layout.jar
	rm commons-codec-1.3.jar && dosym /usr/share/commons-codec/lib/commons-codec.jar ${instdir}/commons-codec-1.3.jar || die
	rm commons-httpclient-3.0.jar && dosym /usr/share/commons-httpclient-3/lib/commons-httpclient.jar ${instdir}/commons-httpclient-3.0.jar || die
	rm commons-httpclient-3.0.1.jar && dosym /usr/share/commons-httpclient-3/lib/commons-httpclient.jar ${instdir}/commons-httpclient-3.0.1.jar || die
	# jakarta-slide-ant-webdav-2.1.jar
	# jakarta-slide-webdavlib-2.1.jar
	rm jdom-1.0.jar && dosym /usr/share/jdom-1.0/lib/jdom.jar ${instdir}/jdom-1.0.jar || die
	# jmunit4cldc10-1.2.1.jar
	# jmunit4cldc11-1.2.1.jar
	# nbactivesync-5.0.jar
	# nb_svg_midp_components.jar
	# netbeans_databindingme.jar
	# netbeans_databindingme_pim.jar
	# netbeans_databindingme_svg.jar
	# netbeans_midp_components_basic.jar
	# netbeans_midp_components_pda.jar
	# netbeans_midp_components_wma.jar
	# org-netbeans-modules-deployment-deviceanywhere.jar
	# org-netbeans-modules-j2me-cdc-platform-nsicom-probe.jar
	# org-netbeans-modules-j2me-cdc-project.jar
	# org-netbeans-modules-j2me-cdc-project-nokiaS80.jar
	# org-netbeans-modules-j2me-cdc-project-ojec.jar
	# org-netbeans-modules-j2me-cdc-project-ricoh.jar
	# org-netbeans-modules-j2me-cdc-project-savaje.jar
	# org-netbeans-modules-j2me-cdc-project-semc.jar
	# org-netbeans-modules-j2me-cdc-project-sjmc.jar
	# perseus-nb-1.0.jar
	# RicohAntTasks-2.0.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/mobility
}
