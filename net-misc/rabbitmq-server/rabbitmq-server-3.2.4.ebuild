# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_DEPEND="2"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils python-single-r1 systemd user

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang"
HOMEPAGE="http://www.rabbitmq.com/"
SRC_URI="http://www.rabbitmq.com/releases/rabbitmq-server/v${PV}/rabbitmq-server-${PV}.tar.gz"

LICENSE="GPL-2 MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/erlang"
DEPEND="${RDEPEND}
	app-arch/zip
	app-arch/unzip
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	dev-libs/libxslt
	dev-python/simplejson
"

pkg_setup() {
	enewgroup rabbitmq
	enewuser rabbitmq -1 -1 /var/lib/rabbitmq rabbitmq
	python-single-r1_pkg_setup
}

src_compile() {
	emake all docs_all
	gunzip docs/*.gz
}

src_install() {
	# erlang module
	local targetdir="/usr/$(get_libdir)/erlang/lib/rabbitmq_server-${PV}"

	einfo "Setting correct RABBITMQ_HOME in scripts"
	sed -e "s:^RABBITMQ_HOME=.*:RABBITMQ_HOME=\"${targetdir}\":g" \
		-i scripts/rabbitmq-env

	einfo "Installing Erlang modules to ${targetdir}"
	insinto "${targetdir}"
	doins -r ebin include plugins

	einfo "Installing server scripts to /usr/sbin"
	for script in rabbitmq-env rabbitmq-server rabbitmqctl rabbitmq-defaults rabbitmq-plugins; do
		exeinto /usr/libexec/rabbitmq
		doexe scripts/${script}
		newsbin "${FILESDIR}"/rabbitmq-script-wrapper ${script}
	done

	# create the directory where our log file will go.
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/log/rabbitmq /etc/rabbitmq

	# create the mnesia directory
	diropts -m 0770 -o rabbitmq -g rabbitmq
	dodir /var/lib/rabbitmq{,/mnesia}

	# install the init script
	newinitd "${FILESDIR}"/rabbitmq-server.init-r3 rabbitmq
	systemd_dounit "${FILESDIR}/rabbitmq.service"

	# install documentation
	doman docs/*.[15]
	dodoc README
}

pkg_preinst() {
	if has_version "<=net-misc/rabbitmq-server-1.8.0"; then
		elog "IMPORTANT UPGRADE NOTICE:"
		elog
		elog "RabbitMQ is now running as an unprivileged user instead of root."
		elog "Therefore you need to fix the permissions for RabbitMQs Mnesia database."
		elog "Please run the following commands as root:"
		elog
		elog "  usermod -d /var/lib/rabbitmq rabbitmq"
		elog "  chown rabbitmq:rabbitmq -R /var/lib/rabbitmq"
		elog
	elif has_version "<net-misc/rabbitmq-server-2.1.1"; then
		elog "IMPORTANT UPGRADE NOTICE:"
		elog
		elog "Please read release notes before upgrading:"
		elog
		elog "http://www.rabbitmq.com/release-notes/README-3.0.0.txt"
	fi
}
