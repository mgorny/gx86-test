# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

#upstream is adding ruby20 support soonish, keep an eye out
USE_RUBY="ruby19"

inherit ruby-ng

DESCRIPTION="Framework to build server orchestration or parallel job execution
systems"
HOMEPAGE="http://marionette-collective.org/"
SRC_URI="http://puppetlabs.com/downloads/mcollective/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc +client"

DEPEND=""
RDEPEND="dev-ruby/stomp"

src_compile() {
	einfo "nothing to compile"
}

each_ruby_install() {
	doruby -r lib/*
	insinto /usr/share/mcollective
	doins -r plugins
	use client && dosbin bin/mco
	dosbin bin/mcollectived
	if use doc ; then
		dohtml -r doc/*
		insinto /usr/share/doc/${P}/ext
		doins -r ext/*
	fi
	newinitd "${FILESDIR}"/mcollectived.initd mcollectived
	insinto /etc/mcollective
	cd etc
	for cfg in *.dist ; do
		newins "${cfg}" "${cfg%%.dist}"
		sed -i -e "s:^libdir.*:libdir = /usr/share/mcollective/plugins:" \
			"${D}"/etc/mcollective/${cfg%%.dist} || die "sed failed"
	done
	insinto /etc/mcollective/plugin.d
}

pkg_postinst() {
	einfo "Mcollective requires a stomp server installed and functioning before"
	einfo "you can use it. The recommended server to use is ActiveMQ [1] but"
	einfo "any other stomp compatible server should work."
	einfo
	einfo "It is recommended you read the \'getting started\' guide [2] if this"
	einfo "is a new installation"
	einfo
	einfo "[1] http://activemq.apache.org/"
	einfo "[2] http://code.google.com/p/mcollective/wiki/GettingStarted"
}
