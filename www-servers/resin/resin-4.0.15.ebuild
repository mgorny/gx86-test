# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils flag-o-matic multilib autotools user

DESCRIPTION="A fast Servlet and JSP engine"
HOMEPAGE="http://www.caucho.com"
SRC_URI="http://www.caucho.com/download/${P}-src.zip
	mirror://gentoo/resin-gentoo-patches-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="admin doc"

KEYWORDS="~amd64 ~x86"

COMMON_DEP="~dev-java/resin-servlet-api-${PV}
	dev-java/glassfish-deployment-api:1.2
	java-virtuals/javamail
	dev-java/jsr101
	dev-java/mojarra:1.2
	dev-java/validation-api:1.0"

RDEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	dev-java/ant-core
	dev-libs/openssl
	${COMMON_DEP}"

RESIN_HOME="/usr/$(get_libdir)/resin"

# Rewrites build.xml in documentation
JAVA_PKG_BSFIX="off"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup resin
	enewuser resin -1 /bin/bash ${RESIN_HOME} resin
}

src_prepare() {
	for i in "${WORKDIR}"/${PV}/resin-${PV}-*; do
		epatch "${i}"
	done;

	# Respect LDFLAGS:
	sed -i -e 's/-o/$(LDFLAGS) -o/' modules/c/src/resin_os/Makefile.in

	# No bundled JARs!
	rm -f "${S}/modules/ext/"*.jar
	rm -rf "${S}/project-jars"

	java-ant_bsfix_one "${S}/build.xml"
	java-ant_bsfix_one "${S}/build-common.xml"

	mkdir -p "${S}/m4"
	eautoreconf

	# Symlink our libraries:
	mkdir -p "${S}/gentoo-deps"
	cd "${S}/gentoo-deps/"
	java-pkg_jar-from --virtual javamail
	java-pkg_jar-from glassfish-deployment-api-1.2
	java-pkg_jar-from resin-servlet-api-3.0 resin-servlet-api.jar
	java-pkg_jar-from mojarra-1.2
	java-pkg_jar-from jsr101
	java-pkg_jar-from validation-api-1.0
	ln -s $(java-config --jdk-home)/lib/tools.jar
}

src_configure() {
	append-flags -fPIC -DPIC

	chmod 755 "${S}/configure"
	econf --prefix=${RESIN_HOME} || die "econf failed"
}

src_compile() {
	einfo "Building libraries..."
	emake || die "make failed"

	einfo "Building jars..."
	eant || die "ant failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	einfo "Moving configuration to /etc ..."
	dodir /etc/
	mv "${D}/${RESIN_HOME}/conf" "${D}/etc/resin" || die "mv of conf failed"
	dosym /etc/resin ${RESIN_HOME}/conf

	einfo "Rewriting resin.xml ..."
	sed -i \
		-e 's,${resin.root}/doc/resin-doc,webapps/resin-doc,' \
		-e 's,${resin.root}/doc/admin,webapps/admin,' \
		"${D}/etc/resin/resin.xml"

	einfo "Fixing log directory ..."
	rm -rf "${D}/${RESIN_HOME}/log"
	keepdir /var/log/resin
	dosym /var/log/resin ${RESIN_HOME}/log

	einfo "Installing basic documentation ..."
	dodoc README "${S}"/conf/*.xml

	einfo "Installing init.d script ..."
	newinitd "${FILESDIR}/${PV}/resin.init" resin
	newconfd "${FILESDIR}/${PV}/resin.conf" resin

	sed -i -e "s,__RESIN_HOME__,${RESIN_HOME},g" "${D}/etc/init.d/resin"

	einfo "Fixing location of jars ..."
	rm -f "${S}/lib/tools.jar"
	java-pkg_dojar "${S}"/lib/*.jar
	rm -fr "${D}/${RESIN_HOME}/lib"
	dosym /usr/share/resin/lib ${RESIN_HOME}/lib

	einfo "Symlinking directories from /var/lib/resin ..."
	rm -rf "${D}/${RESIN_HOME}/resin-data"
	rm -rf "${D}/${RESIN_HOME}/watchdog-data"
	dodir /var/lib/resin/webapps
	keepdir /var/lib/resin/hosts
	keepdir /var/lib/resin/resin-data
	keepdir /var/lib/resin/watchdog-data
	mv "${D}"/${RESIN_HOME}/webapps/* "${D}/var/lib/resin/webapps" || \
		die "mv of webapps failed"
	rm -rf "${D}/${RESIN_HOME}/webapps"
	dosym /var/lib/resin/webapps ${RESIN_HOME}/webapps
	dosym /var/lib/resin/hosts ${RESIN_HOME}/hosts
	dosym /var/lib/resin/resin-data ${RESIN_HOME}/resin-data
	dosym /var/lib/resin/watchdog-data ${RESIN_HOME}/watchdog-data

	dosym \
		"$(java-pkg_getjar resin-servlet-api-3.0 resin-servlet-api.jar)" \
		"${JAVA_PKG_JARDEST}/resin-servlet-api.jar" || die

	use admin && {
		einfo "Installing administration app ..."
		cp -a "${S}/doc/admin" "${D}/var/lib/resin/webapps/" || die
	}
	use doc && {
		einfo "Installing documentation app ..."
		cp -a "${S}/doc/resin-doc" "${D}/var/lib/resin/webapps/" || die
	}

	use source && {
		einfo "Installing sources ..."
		java-pkg_dosrc "${S}"/modules/*/src/* > /dev/null
	}

	einfo "Removing stale directories ..."
	rm -fr "${D}/${RESIN_HOME}/bin"
	rm -fr "${D}/${RESIN_HOME}/doc"
	rm -fr "${D}/${RESIN_HOME}/keys"
	rm -fr "${D}/${RESIN_HOME}/licenses"
	rm -fr "${D}/etc/resin/"*.orig

	einfo "Fixing ownerships and permissions ..."
	chown -R 0:root "${D}/"
	chown -R resin:resin "${D}/etc/resin"
	chown -R resin:resin "${D}/var/lib/resin"
	chown -R resin:resin "${D}/var/log/resin"

	chmod 644 "${D}/etc/conf.d/resin"
	chmod 755 "${D}/etc/init.d/resin"
	chmod 750 "${D}/var/lib/resin"
	chmod 750 "${D}/etc/resin"
}

pkg_postinst() {
	elog
	elog " User and group 'resin' have been added."
	elog
	elog " By default, Resin runs on port 8080. You can change this"
	elog " value by editing /etc/resin/resin.xml."
	elog
}
